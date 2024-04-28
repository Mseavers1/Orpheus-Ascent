extends Node2D

# Math
var math = preload("res://scripts/Math.gd").new()

# Constraints
const minLavaSpeed = 10
const maxLavaSpeed = 300
const catching_up_speed = 400
const max_heght_till_full_ft = 10000
const max_distance_away = 600

# These vars dont mean the actual time... requires eyeballing...
const max_fireball_timer = 80
const min_fireball_timer = 1

# Fireball
var fireball = load("res://scenes/Fireball.tscn")
var chance_to_spawn = 0.7

# Vars
var time = 0
var current_lava_speed
var countdown_expired = false
var is_catching_up = false
var saved_speed
var exponent
var fireball_exponent
var freeze_lava = false

func _ready():
	current_lava_speed = minLavaSpeed
	$AnimatedSprite2D.play()
	
	$Lava_Loop_Sounds.pitch_scale = randf_range(0.5, 4)
	
	exponent = math.log_with_base(maxLavaSpeed - minLavaSpeed, max_heght_till_full_ft)
	fireball_exponent = math.log_with_base(max_fireball_timer - min_fireball_timer, max_heght_till_full_ft)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Lava loop Sounds
	if !$Lava_Loop_Sounds.playing:
		$Lava_Loop_Sounds.play()
	
	if !countdown_expired or freeze_lava:
		return
		
	# Stop closing the gap once reached max speed
	if current_lava_speed < maxLavaSpeed or is_catching_up:
		if math._distance(Vector2(0, position.y), Vector2(0, $"../PlayerCharacter".position.y)) >= max_distance_away && !is_catching_up:
			is_catching_up = true
			saved_speed = current_lava_speed
			current_lava_speed = catching_up_speed
		
		if math._distance(Vector2(0, position.y), Vector2(0, $"../PlayerCharacter".position.y)) < max_distance_away && is_catching_up:
			is_catching_up = false
			current_lava_speed = saved_speed
	
	
	position.y -= delta * current_lava_speed
	
	# Increase speed over the best height
	if !is_catching_up:
		
		var new_speed = get_new_speed()
		
		if new_speed > current_lava_speed:
			current_lava_speed = new_speed

func get_new_speed():
	var height = $"../PlayerCharacter".record_height
	
	return pow(height, exponent) + minLavaSpeed
	
func get_new_fireball_timer():
	var height = $"../PlayerCharacter".record_height
	
	return (max_fireball_timer - (pow(height, fireball_exponent) + min_fireball_timer)) / 100

# Player or coin touches the lava
func _on_collision_entered(body):
	
	if body.is_in_group("Player"):
		body.death()
	
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
			
	# Check if speed increases
	if !is_catching_up:
		var current = $Fireball_Timer.wait_time
		var new_time = get_new_fireball_timer()
		
		# Stop speed once reached the max
		if current > max_heght_till_full_ft:
			return
		
		if new_time < current:
			$Fireball_Timer.wait_time = new_time
			#print(new_time)


func _summon_fireball():
	
	var fireballObj = fireball.instantiate()
	fireballObj.name = "Fireball"
	$"..".add_child(fireballObj)
	fireballObj.set_lava_pos_y(position.y)
	
	var randX = randf_range(100, 1800)
	var randY = randf_range(position.y + 100, position.y + 30)
	
	if !is_catching_up:
		fireballObj.speed = randf_range(current_lava_speed * 2, current_lava_speed * 4)
	
	fireballObj.position = Vector2(randX, randY)


func _on_count_down_start_of_game():
	countdown_expired = true
	$Fireball_Timer.start()
