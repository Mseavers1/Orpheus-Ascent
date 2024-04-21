extends Node2D
var tempspeed = 500

# Constraints
var minLavaSpeed = 2
var maxLavaSpeed = 110

# Fireball
var fireball = load("res://scenes/Fireball.tscn")
var chance_to_spawn = 0.7

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
	
	# Lava loop Sounds
	if !$Lava_Loop_Sounds.playing:
		$Lava_Loop_Sounds.play()
	
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

# Player or coin touches the lava
func _on_collision_entered(body):
	
	if body.is_in_group("Player"):
		print("player")
	
	if body.is_in_group("Coins"):
		body.queue_free()

# Summon fireball
func _fireball_timer_timeout():
	
	var rand = randf_range(0, 1)
	var spawn_chance = chance_to_spawn
	
	# Keep spawning fireballs until spawn_chance fails
	while true:
		
		rand = randf_range(0, 1)
		
		if rand <= spawn_chance:
			_summon_fireball()
			spawn_chance /= 2
		else:
			break
	


func _summon_fireball():
	var fireballObj = fireball.instantiate()
	fireballObj.name = "Fireball"
	$"..".add_child(fireballObj)
	
	var randX = randf_range(25, 1894)
	var randY = randf_range(position.y + 100, position.y + 10)
	
	fireballObj.speed = randf_range(80, 200)
	
	fireballObj.position = Vector2(randX, randY)
