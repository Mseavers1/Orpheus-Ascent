extends Node2D

# Constraints
var minLavaSpeed = 2
var maxLavaSpeed = 110

# Vars
var time = 0
var lavaSpeed = 0

func _ready():
	lavaSpeed = minLavaSpeed
	$AnimatedSprite2D.play()

# Functions that controls how fast the lava goes
func _speed_function_linear(slope):
	lavaSpeed = minLavaSpeed + (slope * time)
	
func _speed_function_log(slope, inside):
	lavaSpeed = minLavaSpeed + (slope * log(inside * (time + 1)))
	
func _speed_function_pow(slope, exp):
	lavaSpeed = minLavaSpeed + (slope * (pow(time, exp)))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# position.y -= delta * lavaSpeed
	# time += delta
	
	# if lavaSpeed < maxLavaSpeed:
		# _speed_function_linear(0.5)
