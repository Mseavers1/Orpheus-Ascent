extends CharacterBody2D

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

var afterimage_pool = []
const afterimage_num = 5
var currently_placed_index = 0

var jump_effect_obj = load("res://scenes/jump_effect.tscn")
var player_animation = load("res://scenes/player_animations.tscn")

var has_played_falling_once = false
var has_played_landing_once = false

var is_facing_right = false
var is_first_contact_with_slide = true

var is_wall_sliding = false
var is_moving_on_floor = false

var current_height = 0
var record_height = 0

const SPEED = 300.0
var max_jump_velocity
var min_jump_velocity

const max_jumps = 2
var jump_count = 0;
var gravity

const max_dashes = 1
var dash_count = 0
var dash_over = true

var coin_value = 100
var coin_bonus = 1
var coin_pitch_restarted = true
var current_coin_pitch = 1

var suffix
var is_metric = true

var score = 0

var controllable = true
var countdown_expired = false
var force_freeze = false

var is_animation_over = true
var is_hit = false
var is_dead = false

@export var sliding_speed = 80

@export var dash_power_x = 800
@export var dash_power_y = 800

@export var wall_jump_power_x = 400
@export var wall_jump_power_y = 0.8
var wall_jump_over = true
var saved_jump_direction = 0

## Kinematic Jumpings from https://www.youtube.com/watch?v=918wFTru2-c
@export var max_jump_height = 3.25 * 64
@export var min_jump_height = 0.5 * 64
@export var jump_duration = 0.5

func reset_ability_icons():
	$"Abilities Icons/Jump 1".show()
	$"Abilities Icons/Jump 2".show()
	$"Abilities Icons/Star".show()

func update_ability_icons():
	if jump_count == 1:
		$"Abilities Icons/Jump 1".hide()
	
	if jump_count > 1:
		$"Abilities Icons/Jump 2".hide()
		
	if dash_count > 0:
		$"Abilities Icons/Star".hide()
	

func _update_conversion():
	
	if is_metric:
		suffix = "m"
	else:
		suffix = "ft"

func check_conversion():
	is_metric = Globals.is_units_meters()
	_update_conversion()

	var value = record_height
		
	if is_metric:
		value = ceil(record_height / 3.281)
	$"../UI/Record".text = "Record: " + str(value) + " " + suffix

func _ready():
	
	# Create afterimages
	for num in range(afterimage_num):
		var obj = player_animation.instantiate()
		obj.hide()
		obj.scale = Vector2(3, 3)
		$"..".add_child.call_deferred(obj)
		afterimage_pool.append(obj)
	
	check_conversion()
	
	$"Pause Controller/Pause Menu/Volume/Master/Master_slider".value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$"Pause Controller/Pause Menu/Volume/Music/music_Slider".value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	$"Pause Controller/Pause Menu/Volume/SFX/Sound_Slider".value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)
	
func _process(_delta):
	
	if record_height < current_height:
		record_height = current_height
		score += ceil(1)
		
		update_score()
		
		var value = record_height
		
		if is_metric:
			value = ceil(record_height / 3.281)
		
		$"../UI/Record".text = "Record: " + str(value) + " " + suffix
		
	current_height = int((950 - int(position.y)) / 25)
	
	if current_height < 0: 
		current_height = 0
	
	var value = current_height
	
	if is_metric:
			value = ceil(current_height / 3.281)
	
	$"../UI/Current_Height_Value".text = str(value) + " " + suffix

func apply_gravity(delta):
	velocity.y += gravity * delta

func jumping():
	
	if !wall_jump_over:
		return
	
	# Start long jump
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count < max_jumps):
		jump_count += 1;
		velocity.y = max_jump_velocity
		
		$Jump_Sound.play()
		$Sprite.play("Jump")
		
		var effect = jump_effect_obj.instantiate()
		$"..".add_child(effect)
		effect.position = position
		
		if jump_count == 1:
			effect.play_jump()
		elif jump_count > 1:
			effect.play_double()
		
	
	# Stops jump -- shortens the jump
	if Input.is_action_just_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
	
	update_ability_icons()

func dash_conditions():
	return (Input.is_action_just_pressed("mouse-click") or Input.is_action_just_pressed("dash")) && dash_count < max_dashes

func dash():
	dash_count += 1
	dash_over = false
	$Dash_Timer.start()
	$Afterimage_placing.start()
	
	$Dash_Sound.play()
	
	var mousePos = get_global_mouse_position()
	var vect = global_position.direction_to(mousePos)
	
	_flip_player(vect.x)
	
	velocity.x += dash_power_x * vect.x
	velocity.y = dash_power_y * vect.y
	
	update_ability_icons()

func wall_jump_conditions():
	return is_on_wall() and Input.is_action_just_pressed("jump")

func wall_jump():
	
	var direction
	
	if is_facing_right: 
		direction = -1 
	else: 
		direction = 1
	
	# No wall jumping if attempting to wall jump on same section
	if direction == saved_jump_direction:
		return
		
	saved_jump_direction = direction
	velocity.y = max_jump_velocity * wall_jump_power_y
	velocity.x = wall_jump_power_x * direction
	_flip_player(direction)
	wall_jump_over = false
	$Wall_Jump_Timer.start()
	
	$Jump_Sound.play()
	
	$Sprite.play("Jump")
	
func on_floor():
	
	# Restore moveability
	controllable = true
	
	# Stop momentum
	velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Reset counters
	dash_count = 0
	jump_count = 0
	saved_jump_direction = 0
	is_hit = false
	
	# Reset other stuff
	is_first_contact_with_slide = true
	reset_ability_icons()

func wall_slide_condition():
	return is_on_wall_only() and (Input.is_action_pressed("move-left") or Input.is_action_pressed("move-right")) and !Input.is_action_pressed("jump") and !Input.is_action_pressed("move-down") and wall_jump_over and dash_over and controllable

func _physics_process(delta):
	
	if !countdown_expired or force_freeze:
		return
	
	# Apply Gravity OR wall slide
	if not is_on_floor():
		
		# Wall Slide
		if wall_slide_condition():
			
			$Sprite.play("Wall")
			
			if is_first_contact_with_slide:
				velocity.y = sliding_speed
			
			is_first_contact_with_slide = false
			velocity.y += sliding_speed * delta
			is_wall_sliding = true
		else:
			apply_gravity(delta)
			is_first_contact_with_slide = true
			
			if is_wall_sliding:
				has_played_falling_once = false
				
			is_wall_sliding = false
	
	# Items processed when player is on the floor
	if is_on_floor():
		on_floor()
		
	# Animation
	if !is_hit:
		if velocity.y < 0:
				
			if has_played_falling_once:
				has_played_falling_once = false
				
		elif velocity.y > 0:
			
			has_played_landing_once = false
			
			if !has_played_falling_once:
				$Sprite.play("Fall")
				has_played_falling_once = true	
			
		elif velocity.y == 0:
			has_played_falling_once = false
			
			if !has_played_landing_once:
				has_played_landing_once = true
				$Sprite.play("Land")
	
	# Prevents movement abilities if player is not controllable
	if !controllable:
		
		# Apply gravity onlu
		move_and_slide()
		return
	
	# Wall jump
	if wall_jump_conditions():
		wall_jump()
	
	# Handles Movement
	movement()
	
	# Handles jumping
	jumping()
	
	# Handles Dashing
	if dash_conditions(): 
		dash()

	# Apply movement
	move_and_slide()
	
func movement():
	
	# Cancels if player can't move
	if !wall_jump_over or !dash_over:
		return
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move-left", "move-right")
	
	_flip_player(direction)
	
	if direction:
		velocity.x = direction * SPEED
		
		if is_on_floor():
			is_moving_on_floor = true
			$Sprite.play("Move")
			
			if !$Walk_Sound.playing:
				$Walk_Sound.play()
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if $Sprite.animation == "Move":
			$Sprite.play("Idle")
			is_moving_on_floor = false

func _flip_player(direction):
	if direction < 0:
			$Sprite.flip_h = true
			is_facing_right = false

	if direction > 0:
		$Sprite.flip_h = false
		is_facing_right = true

func _on_dash_timer_timeout():
	dash_over = true

func update_score():
	$"../UI/Score".text = "Score: " + str(score)

func _on_coin_collector_body_entered(body):
	if body.is_in_group("Coins"):
		
		# If coin & restart, set pitch to 1
		if coin_pitch_restarted:
			# current_coin_pitch = randf_range(0.9, 1.2)
			current_coin_pitch = 1
			coin_pitch_restarted = false
			coin_bonus = 1
		else:
			current_coin_pitch += 0.05
			coin_bonus += 0.1
		
		$Coin_Timer.start()
		body.pickup(current_coin_pitch)
		
		score += coin_value * coin_bonus
		# print(coin_value * coin_bonus)
		update_score()

# Fireball collides with player
func hit():
	controllable = false
	is_hit = true
	velocity.x = randf_range(70, 200) * randi_range(-1, 1)
	velocity.y = -5
	$Sprite.play("Death")

func _on_coin_timer_timeout():
	coin_pitch_restarted = true


func _on_wall_jump_timeout():
	wall_jump_over = true

func death():
	
	if is_dead:
		return
		
	$"../Lava".freeze_lava = true
	is_dead = true
	force_freeze = true
	$Death_Explosion.show()
	$Death_Explosion.play("Explode")
	$Death_Sound.play()
	$"..".is_player_dead = true
	Globals.set_score(score)
	Globals.set_height(record_height)
	$"Abilities Icons".hide()
	$Sprite.hide()
	#$"Pause Controller/Game Over".show()

func to_game():
	get_tree().change_scene_to_file("res://scenes/TempScene.tscn")

func to_menu():
	get_tree().change_scene_to_file("res://scenes/New_menu.tscn")

func to_profile():
	get_tree().change_scene_to_file("res://scenes/profile.tscn")

func _on_upload_score_pressed():
	call_deferred("to_profile")

func to_leaderboards():
	get_tree().change_scene_to_file("res://scenes/leaderboardss.tscn")

func _on_leaderboard_pressed():
	call_deferred("to_leaderboards")


func _on_play_again_button_pressed():
	call_deferred("to_game")


func _on_menu_button_pressed():
	call_deferred("to_menu")

func quit_game():
	get_tree().quit()

func _on_quit_pressed():
	call_deferred("quit_game")


func _on_menu_pressed():
	call_deferred("to_menu")


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < 0.01)


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < 0.01)


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_mute(0, value < 0.01)


func _on_tree_exiting():
	Globals.save_audio()


func _on_count_down_start_of_game():
	countdown_expired = true


func _on_sprite_animation_finished():
	if $Sprite.animation == "Land":
		$Sprite.play("Idle")


func _on_death_explosion_animation_finished():
	$"Pause Controller".force_pause()
	$"Pause Controller/Game Over".show()
	#$Death_Explosion.hide()


func _on_afterimage_placing_timeout():
	if currently_placed_index >= afterimage_num - 1:
		$Afterimage_placing.stop()
		currently_placed_index = 0
		return
		
	var i = afterimage_pool[currently_placed_index]
	
	i.animation = $Sprite.animation
	i.frame = $Sprite.frame
	
	i.flip_h = $Sprite.flip_h
	i.position = position
	i.show()
	i.start_fade()
	currently_placed_index += 1
