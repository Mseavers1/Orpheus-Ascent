extends Node2D

@export var camera: Camera2D
@export var player: RigidBody2D

# Platforms
var platform64x64 = load("res://scenes/Platform_64x64.tscn")
var platform192x64 = load("res://scenes/Platform_192x64.tscn")
var platform256x64 = load("res://scenes/Platform_256x64.tscn")
var platform320x64 = load("res://scenes/Platform_320x64.tscn")
var platform640x64 = load("res://scenes/Platform_640x64.tscn")

var platformH_192x192 = load("res://scenes/PlatformH_192x192.tscn")
var platformH_320x320 = load("res://scenes/PlatformH_320x320.tscn")

var platformL_192x192 = load("res://scenes/PlatformL_192x192.tscn")
var platformL_320x320 = load("res://scenes/PlatformL_320x320.tscn")

var platformT_192x192 = load("res://scenes/PlatformT_192x192.tscn")
var platformT_320x320 = load("res://scenes/PlatformT_320x320.tscn")

var platformS_320x320 = load("res://scenes/PlatformS_320x320.tscn")

var platforms = [platform64x64, platform192x64, platform256x64, platform320x64, platform640x64, platformH_192x192, platformH_320x320, platformL_192x192, platformL_320x320, platformT_192x192, platformT_320x320, platformS_320x320]

# Walls
var walls = load("res://scenes/Walls.tscn")

# Platform Chances -- ADD UP TO 100
var platform64x64_chance = 9.09
var platform192x64_chance = 9.09
var platform256x64_chance = 9.09
var platform320x64_chance = 9.09
var platform640x64_chance = 9.09
var platformH_192x192_chance = 9.09
var platformH_320x320_chance = 9.09
var platformL_192x192_chance = 9.09
var platformL_320x320_chance = 9.09
var platformT_192x192_chance = 9.09
var platformT_320x320_chance = 8.1
var platformS_320x320_chance = 1

# Player Tracking
var quadLast = -2 # loaded behind
var quadCurrent = 0
var quadFirst = 2 # loaded ahead

# Divisions within Quads
var divisorX = 3
var divisorY = 3 # Can't be less than the minPlatformsPerY

# Find top and center of the divisors
var topX = 1920 / divisorX
var centerX = topX / 2

# Find top of the divisors
var topY = (1080 / divisorY)

# Level Generation Numbers
var minPlatformsPerY = 3
var maxPlatformsPerQuad = 6
var chanceForPlatformToSpawn = 0.5

# Constants
var indexOf64x64 = 0
var indexOf192x64 = 1
var indexOf256x64 = 2
var indexOf320x64 = 3
var indexOf640x64 = 4
var indexOfH_192x192 = 5
var indexOfH_320x320 = 6
var indexOfL_192x192 = 7
var indexOfL_320x320 = 8
var indexOfT_192x192 = 9
var indexOfT_320x320 = 10
var indexOfS_320x320 = 11


func _init():
	_error_check()

# Check if chances add up to 100%
func _error_check():
	var total = platform64x64_chance + platform192x64_chance + platform256x64_chance + platform320x64_chance + platform640x64_chance + platformH_192x192_chance + platformH_320x320_chance + platformL_192x192_chance + platformL_320x320_chance + platformT_192x192_chance + platformT_320x320_chance + platformS_320x320_chance
	
	if str(total) != "100":
		assert(false, "Platform chances do not add up to 100 --> They add up to " + str(total))
		
	if divisorY < minPlatformsPerY:
		assert(false, "The min the DivsorY can be is the same number as minPlatformsPerY... DivisorY => " + str(divisorY) + " --- MinPlatformsPerY => " + str(minPlatformsPerY))
		
	if maxPlatformsPerQuad > divisorX * divisorY:
		assert(false, "Max Platform Per Quad must be lower than the number of available spawning sections in a quad... DivisorX: " + str(divisorX) + " DivisorY: " + str(divisorY) + " Total Max Rooms: " + str(divisorX * divisorY))

# Returns a random platform index
func _get_platform():
	var rand = randf_range(0, 100)
	var chances = [platform64x64_chance, platform192x64_chance, platform256x64_chance, platform320x64_chance, platform640x64_chance, platformH_192x192_chance, platformH_320x320_chance, platformL_192x192_chance, platformL_320x320_chance, platformT_192x192_chance, platformT_320x320_chance, platformS_320x320_chance]
	var total = 0
	
	for i in len(chances):
		total += chances[i]
		
		if rand <= total:
			return i
			
	assert(false, "Couldn't generate a platfrom")
	
	

# Returns which quad the player is in
func _get_player_quad():
	
	var quad = quadFirst
	
	for x in (abs(quadLast) + quadFirst + 1):
		
		# Checks if the player is in the quad
		if player.position.y >= (1080 - (1080 * (quad + 1))) and player.position.y < (1080 - (1080 * quad)):
			return quad
			
		quad -= 1

# Generate platforms in a certain quad
func _generate_platforms_in_quad(quad):
	
	# Spawn Walls
	var w = walls.instantiate()
	w.set_name("Walls")
	add_child(w)
	w.position = Vector2(960, -1080 * quad)
	
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
				
				# Add platform to array (location only)
				platformArray[j][i] = true
				
				# Increment rowCounter for new rows
				if y + 1 > rowPlatforms:
					rowPlatforms += 1
				
				totalPlatforms += 1
				
				# Spawn Platform
				_generate_platform_in_divisor(i, j, platformArray, quad)
				

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
	if rand >= chanceForPlatformToSpawn:
		return true
	
	return false

func _generate_platform_in_divisor(i, j, locations, quad):
	
	var platIndex = 0
	var y = (divisorY - 1) - j
	
	# Continue looping through until a valid platform is found
	var hasFoundPlatform = false
	while (!hasFoundPlatform):
	
		hasFoundPlatform = true
	
		# Get random platform
		platIndex = _get_platform()
		
		# If platform is T2 or 64x640 or 64x320-- Can't spawn unless there is no platforms underneath or if on last row of the 0th quad
		if platIndex == indexOfT_320x320 or platIndex == indexOf640x64 or platIndex == indexOf320x64:
			
			print(locations)
			print(str(y-1) + ", " + str(i))
			
			# For now, regenerate if j = 2 / y = 0(Bottom row)
			if y == 0:
				hasFoundPlatform = false
				continue
				
			# Check if platform below is empty
			if locations[y - 1][i] == true:
				hasFoundPlatform = false
				continue
			
			continue
	
	# Spawn Platform
	var plat = platforms[platIndex].instantiate()
	plat.set_name("Platform")
	add_child(plat)
	plat.position = Vector2(centerX + (topX * i), (topY * j) - (1080 * quad))

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
