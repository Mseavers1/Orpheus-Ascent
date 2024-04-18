extends Node2D
var tempspeed = 500

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
	
func _speed_function_pow(slope, exponent):
	lavaSpeed = minLavaSpeed + (slope * (pow(time, exponent)))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var velocity = Vector2.ZERO;
		
	if Input.is_action_pressed("move-lava-down") :
		velocity.y += 1;
		
	if Input.is_action_pressed("move-lava-up") :
		velocity.y -= 1;
		
	if velocity.length() > 0 :
		velocity = velocity.normalized() * tempspeed;
		
	position += velocity*delta;
	
	pass
	# position.y -= delta * lavaSpeed
	# time += delta
	
	# if lavaSpeed < maxLavaSpeed:
		# _speed_function_linear(0.5)
