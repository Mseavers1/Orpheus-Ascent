extends Node2D

@export var camera: Camera2D
@export var player: RigidBody2D

var platform1 = load("res://scenes/Platform_1.tscn")
var platform2 = load("res://scenes/Platform_2.tscn")
var platform3 = load("res://scenes/Platform_3.tscn")
var platform4 = load("res://scenes/Platform_4.tscn")
var platform5 = load("res://scenes/Platform_5.tscn")

# Couldnt figure out how to get resolution using code
var screen = Vector2(1920, 1080)
var spawning = false

var xRange = 600
var platform1Width = 192
var platforms = []

func yDistance(y1, y2):
	return pow(pow(y2 - y1, 2), 1.0/2.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in 10:
		var plat = platform1.instantiate()
		plat.set_name("Platform")
		add_child(plat)
		
		var xPos = screen.x / 2
		
		if len(platforms) > 0:
			var lastPos = platforms[x - 1].position
			
			var ran = randf_range(0, 1)
			
			# Right
			if ran >= 0.5:
				ran = randf_range((lastPos.x + (platform1Width / 2)), lastPos.x + xRange)
			# Left
			else:
				ran = randf_range((lastPos.x - (platform1Width / 2)), lastPos.x - xRange)
			
			xPos = ran
			
			if xPos < 0:
				xPos = platform1Width
			elif xPos > screen.x:
				xPos = screen.x - platform1Width
		
		plat.position = Vector2(xPos, 700 - (x * 200))
		platforms.append(plat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	camera.position = Vector2(camera.position.x, player.position.y)
	
	if yDistance(platforms[-1].position.y, player.position.y) < 500 and !spawning:
		print('Spawning Platforms')
		spawning = true
		spawnPlatforms(platforms[-1].position.y)

func spawnPlatforms(starting_y):
	for x in 10:
		
		if x == 0:
			continue
		
		var plat = platform1.instantiate()
		plat.set_name("Platform")
		add_child(plat)
		
		var xPos = screen.x / 2
		
		var lastPos = platforms[-1].position
		
		var ran = randf_range(0, 1)
		
		# Right
		if ran >= 0.5:
			ran = randf_range((lastPos.x + (platform1Width / 2)), lastPos.x + xRange)
		# Left
		else:
			ran = randf_range((lastPos.x - (platform1Width / 2)), lastPos.x - xRange)
			
		xPos = ran
		
		if xPos - (platform1Width / 2) < 0:
			xPos = platform1Width / 2
		elif xPos + (platform1Width / 2) > screen.x:
			xPos = screen.x - platform1Width / 2
		
		plat.position = Vector2(xPos, starting_y - (x * 200))
		platforms.append(plat)
	
	spawning = false
