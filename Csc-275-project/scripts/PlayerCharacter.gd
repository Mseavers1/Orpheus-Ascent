extends CharacterBody2D


const SPEED = 300.0
var max_jump_velocity
var min_jump_velocity

const max_jumps = 2
var jump_count = 0;
var gravity

const max_dashes = 1
var dash_count = 0
var dash_over = true

var coin_pitch_restarted = true
var current_coin_pitch = 1

@export var dash_power_x = 800
@export var dash_power_y = 800

## Kinematic Jumpings from https://www.youtube.com/watch?v=918wFTru2-c
@export var max_jump_height = 3.25 * 64
@export var min_jump_height = 0.5 * 64
@export var jump_duration = 0.5

func _ready():
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		$Sprite.play("jump");
		velocity.y += gravity * delta
		
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count < max_jumps):
		jump_count += 1;
		velocity.y = max_jump_velocity
	
	if Input.is_action_just_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
		
	if is_on_floor():
		dash_count = 0
		$Sprite.play("idle");
		jump_count = 0;

	if dash_over:
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("move-left", "move-right")
		
		_flip_player(direction)
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Dashing
	if Input.is_action_just_pressed("mouse-click") && dash_count < max_dashes:
		dash_count += 1
		dash_over = false
		$Dash_Timer.start()
		
		var mousePos = get_global_mouse_position()
		var vect = global_position.direction_to(mousePos)
		
		_flip_player(vect.x)
		
		velocity.x += dash_power_x * vect.x
		velocity.y = dash_power_y * vect.y

	move_and_slide()

func _flip_player(direction):
	if direction < 0:
			$Sprite.flip_h = true

	if direction > 0:
		$Sprite.flip_h = false

func _on_dash_timer_timeout():
	dash_over = true


func _on_coin_collector_body_entered(body):
	if body.is_in_group("Coins"):
		
		# If coin & restart, set pitch to 1
		if coin_pitch_restarted:
			# current_coin_pitch = randf_range(0.9, 1.2)
			current_coin_pitch = 1
			coin_pitch_restarted = false
		else:
			current_coin_pitch += 0.2
		
		$Coin_Timer.start()
		body.pickup(current_coin_pitch)


func _on_coin_timer_timeout():
	coin_pitch_restarted = true
