extends CharacterBody2D


const SPEED = 300.0
var max_jump_velocity
var min_jump_velocity

var jump_count = 0;
var gravity

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

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count < 2):
		jump_count += 1;
		velocity.y = max_jump_velocity
	
	if Input.is_action_just_released("jump") && velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
		
	if is_on_floor():
		$Sprite.play("idle");
		jump_count = 0;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move-left", "move-right")
	
	if direction < 0:
		$Sprite.flip_h = true

	if direction > 0:
		$Sprite.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
