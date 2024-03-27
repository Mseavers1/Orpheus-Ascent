extends Node2D

@export var camera: Camera2D
@export var player: RigidBody2D

# Platform Json
var platform_file = "res://jsons/platforms.json"
var platform_marigins = Vector2(64, 64)

# Temp Platform Placeholder
var platform = load("res://scenes/PlaceholderPlatform.tscn")
var saved_platforms := {}
var saved_walls := {}

# Walls
var wall = load("res://scenes/Wall.tscn")

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
var minPlatformsPerY = 4
var maxPlatformsPerQuad = 20
var chanceForPlatformToNotSpawn = 0.3

func _init():
	_error_check()

# Check if chances add up to 100%
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
				
				# Get Data from json file
				var data = loadData(platform_file)
				
				# Ensure chances add up to 100
				validate_data(data)
				
				# Get random Platform
				var available_platforms = get_potential_platform(data)
				var chances = get_chances(data, available_platforms)
				var id = get_random_id(chances)
				var sizeData = data[str(id)]["Size"]
				var size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
				var name = data[str(id)]["Name"]
				
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
				
				var floorSize = Vector2(832, 64) + platform_marigins
				var floor_topLeft = Vector2($Floor.position.x - (floorSize.x / 2), $Floor.position.y - (floorSize.y / 2))
				var floor_bottomRight = Vector2($Floor.position.x + (floorSize.x / 2), $Floor.position.y + (floorSize.y / 2))
				
				var spawn_platform = true
				
				# Wall / Floor Checking 
				while (do_overlap(topLeft, bottomRight, leftWall_topLeft, leftWall_bottomRight) or do_overlap(topLeft, bottomRight, rightWall_topLeft, rightWall_bottomRight) or do_overlap(topLeft, bottomRight, floor_topLeft, floor_bottomRight)):
					
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
					sizeData = data[str(id)]["Size"]
					size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
					name = data[str(id)]["Name"]
					
					# If size is larger than old size, generate a new one
					var attempts = 0
					while size.x >= old_size.x or size.y >= old_size.y:
						
						attempts += 1
						# Stop if there is no sizes smaller
						if chances == null or attempts >= len(data):
							spawn_platform = false
							break
						
						id = get_random_id(chances)
						sizeData = data[str(id)]["Size"]
						size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						name = data[str(id)]["Name"]
					
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
					while (do_overlap(topLeft, bottomRight, curr_topLeft, curr_bottomRight) and spawn_platform):
						# print ("Collision Detected")
						available_platforms.erase(str(id))
						chances[id] = 0
						chances = update_chances(chances)
						
						if chances == null:
							spawn_platform = false
							break
						
						var old_size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						id = get_random_id(chances)
						sizeData = data[str(id)]["Size"]
						size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
						name = data[str(id)]["Name"]
						
						# If size is larger than old size, generate a new one
						var attempts = 0
						while size.x >= old_size.x or size.y >= old_size.y:
							
							attempts += 1
							# Stop if there is no sizes smaller
							if chances == null or attempts >= len(data):
								spawn_platform = false
								break
							
							id = get_random_id(chances)
							sizeData = data[str(id)]["Size"]
							size = Vector2(sizeData[0] + platform_marigins.x, sizeData[1] + platform_marigins.y)
							name = data[str(id)]["Name"]
						
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
				
				# Get random ID
				var plat = platform.instantiate()
				
				plat.set_name("Platform")
				add_child(plat)
				plat.position = platformPos
				
				if !saved_platforms.has(quad):
					saved_platforms[quad] = []
				
				var stored_arr = saved_platforms[quad]
				stored_arr.append(plat)
				saved_platforms[quad] = stored_arr
				# print(str(j) + " " + str(i) + " --> " + str(platformPos) + " QUAD: " + str(quad))
				plat.generate_platform(name + str(size.x - platform_marigins.x) + "x" + str(size.y - platform_marigins.y), size, platformPos)

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
func get_random_id(available_chances):
	
	var rand = randf_range(0, 100)
	var total = 0
	var id = 0
	
	for chance in available_chances:
		total += chance
		
		if rand <= total:
			return id
		
		id += 1
		
	return 0

## From https://www.geeksforgeeks.org/find-two-rectangles-overlap/
# Returns true if two rectangles(l1, r1) and (l2, r2) overlap
func do_overlap(l1, r1, l2, r2):
	
	# if rectangle has area 0, no overlap
	if l1.x == r1.x or l1.y == r1.y or r2.x == l2.x or l2.y == r2.y:
		return false
	 
	# If one rectangle is on left side of other
	if l1.x > r2.x or l2.x > r1.x:
		return false

	# If one rectangle is above other (fixed for godot plane as y is increasing downwards)
	if r1.y < l2.y or r2.y < l1.y:
		return false

	return true

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
	_generate_platforms_in_quad(0)
	_generate_platforms_in_quad(1)
	_generate_platforms_in_quad(2)

func _process(delta):
	
	# Have Camera follow the player (TEMPORARY)
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
		if saved_platforms.has(lavaQuad_current - 2):
			
			print("Deleting a quad")
			
			# Delete the walls of the quad
			for walls in saved_walls[lavaQuad_current - 2]:
				walls.queue_free()
				
			# Delete the floor after reaching the 2nd quad
			if quadCurrent == 2:
				$Floor.queue_free()
			
			# Delete the actual objects
			for plat in saved_platforms[lavaQuad_current - 2]:
				plat.queue_free()
			
			# Clear the references
			saved_platforms.erase([lavaQuad_current - 2])
