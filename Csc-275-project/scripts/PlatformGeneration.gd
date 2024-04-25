extends Node2D

## NOTICE: Integer Division warning has been removed for readability in console - Can be enabled if desired ##
## NOTICE: Use the platform sorter in the project folder if adding or removing platforms in the json file ##

@export var camera: Camera2D
@export var player: CharacterBody2D

# Math script
var math = preload("res://scripts/Math.gd").new()

# Pickups
var pickup_file = "res://jsons/pickups.json"
var coin = load("res://scenes/Coin.tscn")
var saved_coins := {}
var coin_data

# Platform Json
var platform_file = "res://jsons/platforms.json"
var platform_marigins = Vector2(80, 80)
var platform_data

# Temp Platform Placeholder
var platform = load("res://scenes/PlaceholderPlatform.tscn")
var saved_platforms := {}
var saved_walls := {}

# Walls
var wall = load("res://scenes/Wall.tscn")

# Floor
var is_floor_deleted = false

# Player Tracking
var quadLast = -2 # loaded behind
var quadCurrent = 0
var quadFirst = 2 # loaded ahead

# Lava Tracking
var lavaQuad_current = 0

# Divisions within Quads (grid)
var divisorX = 6
var divisorY = 4 # Can't be less than the minPlatformsPerY

# Find top and center of the divisors
var topX = 1920 / divisorX
var centerX = topX / 2

# Find top of the divisors
var topY = (1080 / divisorY)

# Level Generation Numbers
var minPlatformsPerY = 4 # How many platforms should generate on the Y division (cap at divisorY)
var maxPlatformsPerQuad = 10
var chanceForPlatformToNotSpawn = 0.3

func _init():
	_error_check()
	
	# Get json platform data
	platform_data = loadData(platform_file)
	
	# Ensure chances add up to 100
	validate_data(platform_data)
	
	# Get json for coin data
	coin_data = loadData(pickup_file)

func _error_check():
		
	if divisorY < minPlatformsPerY:
		assert(false, "The min the DivsorY can be is the same number as minPlatformsPerY... DivisorY => " + str(divisorY) + " --- MinPlatformsPerY => " + str(minPlatformsPerY))
		
	if maxPlatformsPerQuad > divisorX * divisorY:
		assert(false, "Max Platform Per Quad must be lower than the number of available spawning sections in a quad... DivisorX: " + str(divisorX) + " DivisorY: " + str(divisorY) + " Total Max Rooms: " + str(divisorX * divisorY))
	
# Returns which quad the player is in
func _get_player_quad():
	
	var quad = quadFirst
	
	for x in (abs(quadLast) + quadFirst + 1):
		
		# Checks if the player is in the quad
		if player.position.y >= (1080 - (1080 * (quad + 1))) and player.position.y < (1080 - (1080 * quad)):
			return quad
			
		quad -= 1

# Returns which quad the lava is in
func _get_lava_quad():
	
	var quad = quadFirst
	
	for x in (abs(quadLast) + quadFirst + 1):
		
		# Checks if the player is in the quad
		if $Lava.position.y >= (1080 - (1080 * (quad + 1))) and $Lava.position.y < (1080 - (1080 * quad)):
			return quad
			
		quad -= 1

# From https://www.reddit.com/r/godot/comments/17x2dmj/checking_if_a_file_exists_and_related_functions/ -- written by JohnoThePyro -- edited by Michael Seavers
func loadData(file):
	if FileAccess.file_exists(file):
		var generatedfile = FileAccess.open(file,FileAccess.READ)
		var data = JSON.parse_string(generatedfile.get_as_text())
		
		return data
	else:
		assert(false, "The file: " + file + " does not exsist!")

# Create a dictionary of each platform via their index and chance
func generate_chances(p_data):
	
	var dic = {}
	
	for line in len(p_data):
		dic[line] = p_data[str(line)]["Chance"]
	
	return dic
	
# Create a dictionary of each platform via their index and size
func generate_sizes(p_data):
	
	var dic = {}
	
	for line in len(p_data):
		dic[line] = p_data[str(line)]["Size"]
	
	return dic

# Generate platforms in a certain quad
func _generate_platforms_in_quad(quad):
	
	# Spawn Walls
	var wallLeft = wall.instantiate()
	var wallRight = wall.instantiate()
	
	wallLeft.set_name("Wall_Left")
	wallRight.set_name("Wall_Right")
	
	add_child(wallLeft)
	add_child(wallRight)
	
	wallLeft.position = Vector2(0, -(1080) * quad)
	wallRight.position = Vector2(1920, -(1080) * quad)
	
	var walls = [wallLeft, wallRight]
	saved_walls[quad] = walls
	
	# Platforms
	var platformArray = []
	
	# Creates the placeholder for the platforms generated in the quad
	for row in divisorY:
		platformArray.append([])
		
		for col in divisorX:
			platformArray[row].append(false)
	
	var rowPlatforms = 0
	var totalPlatforms = 0
	
	# Create divisor
	for y in divisorY:
		for i in divisorX:
			
			var j = (divisorY - 1) - y
			
			# Check if at the end of the column
			var isLastCol = false
			
			if i == divisorX - 1:
				isLastCol = true
			
			# Checks if platform can spawn in section
			if _can_spawn_platforms_in_quad(rowPlatforms, totalPlatforms, y, isLastCol):
				
				var platformPos = Vector2(centerX + (topX * i), (topY * j) - (1080 * quad))
				
				# Get random Platform
				var available_platforms = get_potential_platform(platform_data)
				# var available_sizes = generate_sizes(platform_data)
				var available_chances = generate_chances(platform_data)
				
				var chances = get_chances(platform_data, available_platforms)
				var id = get_random_id(available_chances)
				var sizeData = platform_data[str(id)]["Size"]
				var size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
				var p_name = platform_data[str(id)]["Name"]
				
				## Check if platform fits ##
				var topLeft = Vector2(platformPos.x - (size.x / 2), platformPos.y - (size.y / 2))
				var bottomRight = Vector2(platformPos.x + (size.x / 2), platformPos.y + (size.y / 2))
				
				# Compare to walls & floor
				var wallSize = Vector2(64, 1080) + platform_marigins
				
				var leftWall_center = Vector2(wallLeft.position.x, wallLeft.position.y + (wallSize.y / 2))
				var leftWall_topLeft = Vector2(leftWall_center.x - (wallSize.x / 2), leftWall_center.y - (wallSize.y / 2))
				var leftWall_bottomRight = Vector2(leftWall_center.x + (wallSize.x / 2), leftWall_center.y + (wallSize.y / 2))
				
				var rightWall_center = Vector2(wallRight.position.x, wallRight.position.y + (wallSize.y / 2))
				var rightWall_topLeft = Vector2(rightWall_center.x - (wallSize.x / 2), rightWall_center.y - (wallSize.y / 2))
				var rightWall_bottomRight = Vector2(rightWall_center.x + (wallSize.x / 2), rightWall_center.y + (wallSize.y / 2))
				
				var floorSize
				var floor_topLeft
				var floor_bottomRight  
				
				if !is_floor_deleted:
					floorSize = Vector2(632, 576) + platform_marigins
					floor_topLeft = Vector2($Floor.position.x - (floorSize.x / 2), $Floor.position.y - (floorSize.y / 2))
					floor_bottomRight = Vector2($Floor.position.x + (floorSize.x / 2), $Floor.position.y + (floorSize.y / 2))
				
				var spawn_platform = true
				
				# Wall / Floor Checking 
				while (math.do_overlap(topLeft, bottomRight, leftWall_topLeft, leftWall_bottomRight) or math.do_overlap(topLeft, bottomRight, rightWall_topLeft, rightWall_bottomRight) or math.do_overlap(topLeft, bottomRight, floor_topLeft, floor_bottomRight)):
					
					# Removes the current
					available_platforms.erase(str(id))
					chances[id] = 0
					chances = update_chances(chances)	
					
					if chances == null:
						spawn_platform = false
						break
					
					var old_size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
					
					# Generate new id
					id = get_random_id(chances)
					sizeData = platform_data[str(id)]["Size"]
					size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
					p_name = platform_data[str(id)]["Name"]
					
					# If size is larger than old size, generate a new one
					var attempts = 0
					while size.x >= old_size.x or size.y >= old_size.y:
						
						attempts += 1
						# Stop if there is no sizes smaller
						if chances == null or attempts >= len(platform_data):
							spawn_platform = false
							break
						
						id = get_random_id(chances)
						sizeData = platform_data[str(id)]["Size"]
						size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						p_name = platform_data[str(id)]["Name"]
					
					topLeft = Vector2(platformPos.x - (size.x / 2), platformPos.y - (size.y / 2))
					bottomRight = Vector2(platformPos.x + (size.x / 2), platformPos.y + (size.y / 2))
				
				# Detect surrounding cells and see if they collide
				var compareablePlaforms = []
				
				# Get all platform in the current quad
				if saved_platforms.has(quad):
					
					var saved_array = saved_platforms[quad]
					
					for p in saved_array:
						compareablePlaforms.append(p)
				
				# Get all platforms in the previous quad
				if saved_platforms.has(quad - 1):
					
					var saved_array = saved_platforms[quad - 1]
					
					for p in saved_array:
						compareablePlaforms.append(p)
				
				# Search through the combined platforms in both quads
				for p in compareablePlaforms:
					# Get that platfrom infomation
					var curr_size = p.platform_size
					var curr_topLeft = Vector2(p.platform_pos.x - (curr_size.x / 2), p.platform_pos.y - (curr_size.y / 2))
					var curr_bottomRight = Vector2(p.platform_pos.x + (curr_size.x / 2), p.platform_pos.y + (curr_size.y / 2))
					
					# print("Comparing rect " + str(topLeft) + " " + str(bottomRight) + " with " + str(curr_topLeft) + " " + str(curr_bottomRight))
					
					# Calculate if they collide -- repeat generation until it doesnt collide
					while (math.do_overlap(topLeft, bottomRight, curr_topLeft, curr_bottomRight) and spawn_platform):
						# print ("Collision Detected")
						available_platforms.erase(str(id))
						chances[id] = 0
						chances = update_chances(chances)
						
						if chances == null:
							spawn_platform = false
							break
						
						var old_size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						id = get_random_id(chances)
						sizeData = platform_data[str(id)]["Size"]
						size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						p_name = platform_data[str(id)]["Name"]
						
						# If size is larger than old size, generate a new one
						var attempts = 0
						while size.x >= old_size.x or size.y >= old_size.y:
							
							attempts += 1
							# Stop if there is no sizes smaller
							if chances == null or attempts >= len(platform_data):
								spawn_platform = false
								break
							
							id = get_random_id(chances)
							sizeData = platform_data[str(id)]["Size"]
							size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
							p_name = platform_data[str(id)]["Name"]
						
						topLeft = Vector2(platformPos.x - (size.x / 2), platformPos.y - (size.y / 2))
						bottomRight = Vector2(platformPos.x + (size.x / 2), platformPos.y + (size.y / 2))
						
						# print("New Check: " + str(topLeft) + " " + str(bottomRight) + " with a previous: " + str(curr_topLeft) + " " + str(curr_bottomRight))
					
				# Skips this spawning (Spawns nothing)
				if !spawn_platform:
					continue
				
				# Add platform to array (location only)
				platformArray[j][i] = true
				
				# Increment rowCounter for new rows
				if y + 1 > rowPlatforms:
					rowPlatforms += 1
				
				totalPlatforms += 1
				
				## Spawn Platform ##
				
				# Get Free platform from pool
				var plat = platform.instantiate()
				plat.set_name("Platform")
				add_child(plat)
				
				plat.position = platformPos
				
				# Spawn Pickups?
				var pickup_spawned = pickups_logic(Vector2(platformPos.x, platformPos.y - (size.y - platform_marigins.y) * 0.5), quad, plat, Vector2(size.x - platform_marigins.x, size.y - platform_marigins.y))
				
				if !saved_platforms.has(quad):
					saved_platforms[quad] = []
				
				var stored_arr = saved_platforms[quad]
				stored_arr.append(plat)
				saved_platforms[quad] = stored_arr
				# print(str(j) + " " + str(i) + " --> " + str(platformPos) + " QUAD: " + str(quad))
				
				# Spawn Platform
				plat.generate_platform(p_name + str(size.x - platform_marigins.x) + "x" + str(size.y - platform_marigins.y), Vector2(size.x, size.y), platformPos, platform_marigins, pickup_spawned)

# Handles spawning pickups and when they should spawn
func pickups_logic(platform_top, quad, current, currentSize):
	
	const checking_range = 500
	
	## Should coin spawn? ##
	var rand = randf_range(0, 1)
	
	# Can a coin spawn?
	if rand <= coin_data["Coin"]["Spawning_Chance"] and (!saved_coins.has(quad) or len(saved_coins[quad]) < coin_data["Coin"]["Max_Coins_Spawned_Per_Quad"]):
		
		# Finds out what type of coin will be spawned (land or air)
		rand = randf_range(0, 1)

		if rand <= coin_data["Coin"]["Chance_to_Spawn_in_Air"]:
			
			# Get platform to connect to
			var available_platforms = []
			
			if saved_platforms.has(quad):
				for plat in saved_platforms[quad]:
					available_platforms.append(plat)
				
			if quad != 0:
				for plat in saved_platforms[quad - 1]:
					available_platforms.append(plat)
			
			var spawn_platform
			var selected_platform
			
			if len(available_platforms) > 0:
				selected_platform = available_platforms.pick_random()
				spawn_platform = true
			else:
				spawn_platform = false
			
			# Check if that selected platform is too far away
			while selected_platform != null and math._distance(platform_top, selected_platform.position) > checking_range and !selected_platform.has_pickup and spawn_platform:
				#print(_distance(platform_center, selected_platform.position))
				available_platforms.erase(selected_platform)
				
				if len(available_platforms) == 0:
					spawn_platform = false
					break
					
				selected_platform = available_platforms.pick_random()
			
			# If can not find another platform, spawn a reg coin
			if !spawn_platform or selected_platform == null or selected_platform.has_pickup:
				spawn_coin_1(platform_top, quad)
				return true
			
			spawn_coin_2(platform_top, quad, selected_platform, current, currentSize)
		else:
			spawn_coin_1(platform_top, quad)
		
		return true
	
	return false

# Spawn a coin in the air
func spawn_coin_2(platform_top, quad, other, current, currentSize):
	
	# print("spawned")
	var use_linear = true
	
	# Get points above each platform
	var p1 = Vector2(platform_top.x, platform_top.y - 32)
	var p2 = Vector2(other.position.x, other.position.y - ((other.platform_size.y - platform_marigins.y) * 0.5) - 32)
	
	# Find Linear Slope
	var slope = (p2.y - p1.y) / (p2.x - p1.x)
	var b = -slope * p1.x + p1.y
	
	# Get Rectangle for the platform being currently spawned
	var tl = current.position - currentSize
	var br = current.position + currentSize
	
	# Check if the line segment will intersept with the platform
	if math.lineRect(p1.x, p1.y, p2.x, p2.y, tl.x, tl.y, br.x, br.y):
		# print("collide_current")
		use_linear = false
		
	# Get Rectangle for the platform previously spawned
	tl = other.position - other.platform_size
	br = other.position + other.platform_size
	
	# Check if the line segment will intersept with the platform
	if math.lineRect(p1.x, p1.y, p2.x, p2.y, tl.x, tl.y, br.x, br.y):
		# print("collide_other")
		use_linear = false
		
	# If a the line segment intersects, use a quadratic instead
	if !use_linear:
		var p3
		var height = 20
		
		if p2.y < p1.y:
			p3 = Vector2((p1.x + p2.x) / 2, p2.y - height)
		else:
			p3 = Vector2((p1.x + p2.x) / 2, p1.y - height)
		
		var sol = math.findSolution([[pow(p1.x, 2), p1.x, 1, p1.y], [pow(p3.x, 2), p3.x, 1, p3.y], [pow(p2.x, 2), p2.x, 1, p2.y]])
		
		# Unable to find a quadratic formula
		if sol == null:
			spawn_coin_1(platform_top, quad)
			return
			
		# print("Test!")
		
		# If found, find other position within the formula for coins to spawn
		var p5 = Vector2((p1.x + p3.x) / 2, math.solve_quad(sol, (p1.x + p3.x) / 2))
		var p6 = Vector2((p2.x + p3.x) / 2, math.solve_quad(sol, (p2.x + p3.x) / 2))
		
		# Check if the coin paths hit any obsticals
		## Is Important? ##
		
		# Spawn Coins
		var coinObj = coin.instantiate()
		coinObj.name = "Coin1"
		add_child(coinObj)
		coinObj.position = p5
		
		coinObj = coin.instantiate()
		coinObj.name = "Coin2"
		add_child(coinObj)
		coinObj.position = p6
		
		coinObj = coin.instantiate()
		coinObj.name = "Coin3"
		add_child(coinObj)
		coinObj.position = p3
		
		coinObj = coin.instantiate()
		coinObj.name = "Coin4"
		add_child(coinObj)
		coinObj.position = p1
		
		coinObj = coin.instantiate()
		coinObj.name = "Coin5"
		add_child(coinObj)
		coinObj.position = p2
		
		if !saved_coins.has(quad):
			var t_arr = []
			saved_coins[quad] = t_arr

		var arr = saved_coins[quad]
		arr.append(coinObj)
		saved_coins[quad] = arr
	else: 
	
		var halfwayX = (p1.x + p2.x) / 2
		var halfwayY = (slope * halfwayX) + b
		
		var coinObj = coin.instantiate()
		add_child(coinObj)
		coinObj.position = Vector2(halfwayX, halfwayY)
		
		coinObj = coin.instantiate()
		add_child(coinObj)
		coinObj.position = p1
		
		coinObj = coin.instantiate()
		add_child(coinObj)
		coinObj.position = p2
	
		if !saved_coins.has(quad):
			var t_arr = []
			saved_coins[quad] = t_arr

		var arr = saved_coins[quad]
		arr.append(coinObj)
		saved_coins[quad] = arr

# Spawns a coin above a platform
func spawn_coin_1(platform_top, quad):
	var coinObj = coin.instantiate()
	coinObj.name = "Coin"
	add_child(coinObj)
	coinObj.position = Vector2(platform_top.x, platform_top.y - 32)
	
	if !saved_coins.has(quad):
		var t_arr = []
		saved_coins[quad] = t_arr
	
	var arr = saved_coins[quad]
	arr.append(coinObj)
	saved_coins[quad] = arr

func validate_data(data):
	
	var total = 0
	
	for line in len(data):
		var chance = data[str(line)]["Chance"]
		total += chance
	
	if total < 100 or abs(100 - total) > 0.01:
		assert(false, "The chances inside the json file do not add up to 100!!! Only to: " + str(total) + " [" + str(100 - total) + "]")

func get_chances(data, available_platforms):
	
	var chances = []
	for line in len(data):
		
		var chance = data[str(line)]["Chance"]
		if str(line) == available_platforms[line]:
			chances.append(chance)
		else:
			chances.append(0)
	
	return chances
	
func update_chances(chances):
	
	# Find the number of 0 in chance
	var numZeros = 0
	var total = 0
	
	for chance in chances:
		total += chance
		
		if chance == 0:
			numZeros += 1
	
	# Add remainder evently to all other chances
	var numNonZeroes = len(chances) - numZeros
	
	if numNonZeroes == 0:
		return null
	
	var remainder = (100 - total) / numNonZeroes
	var updatedChances = []
	
	for chance in chances:
		
		if chance != 0:
			updatedChances.append(chance + remainder)
		else:
			updatedChances.append(0)
	
	return updatedChances

func get_potential_platform(data):
	
	var pot = []
	
	for line in len(data):
		pot.append(str(line))
	
	return pot


# Gets a random id based on the chances of each platform
func get_random_id(chances):
	
	var rand = randf_range(0, 100)
	var total = 0
	
	for id in chances:
		total += chances[id]
		
		if rand <= total:
			return int(id)
		
	return 0

# Returns if platforms can spawn based on current number of platforms
func _can_spawn_platforms_in_quad(rows, total, currentRow, isLastCol):
	
	var rand = randf_range(0, 1)
	
	# Spawn if at the end of the col but no platforms have spawn in the row
	if (isLastCol and currentRow + 1 > rows):
		return true
	
	# Don't spawn if reached the max platforms
	if total >= maxPlatformsPerQuad:
		return false
	
	# Chance to spawn
	if rand >= chanceForPlatformToNotSpawn:
		return true
	
	return false

func _ready():
	
	Globals.load_new_scened()
	
	# Spawn first 3 chunks / quads
	_generate_platforms_in_quad(0)
	_generate_platforms_in_quad(1)
	_generate_platforms_in_quad(2)


func _process(_delta):

	# Temp maybe? 
	if !$PlayerCharacter:
		return

	# Have Camera follow the player
	camera.position = Vector2(camera.position.x, player.position.y)
	
	# Check if player moved onto the next quad
	var prevQuad = quadCurrent
	var now = _get_player_quad()
	
	
	# If so, generate new quad
	if now > prevQuad:
		quadCurrent = now
		quadFirst += 1
		quadLast += 1
		
		_generate_platforms_in_quad(quadFirst)
		
	
	# Lava Checking
	var lavaQuad_now = _get_lava_quad()
	var lavaQuad_prev = lavaQuad_current
	
	if lavaQuad_now > lavaQuad_prev:
		lavaQuad_current = lavaQuad_now
		
		# Delete all platforms from the quad 2 below the current quad ( if on 5 --> delete quad 3 platforms )
		if saved_platforms.has(lavaQuad_current - 3):
			
			# print("Deleting a quad")
			
			# Delete the walls of the quad
			for walls in saved_walls[lavaQuad_current - 3]:
				walls.queue_free()
				
			# Delete the floor after reaching the 2nd quad
			if quadCurrent == 2:
				is_floor_deleted = true
				$Floor.queue_free()
			
			# Delete all the platforms in the quad
			for plat in saved_platforms[lavaQuad_current - 3]:
				plat.queue_free()
			
			# Clear the references
			saved_platforms.erase([lavaQuad_current - 3])
