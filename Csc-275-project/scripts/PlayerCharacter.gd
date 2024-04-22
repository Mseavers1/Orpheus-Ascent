extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var jump_count = 0;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		$Sprite.play("jump");
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or jump_count < 2):
		jump_count += 1;
		velocity.y = JUMP_VELOCITY
		
	if is_on_floor():
		$Sprite.play("idle");
		jump_count = 0;

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction < 0:
		$Sprite.flip_h = true

	if direction > 0:
		$Sprite.flip_h = false
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
