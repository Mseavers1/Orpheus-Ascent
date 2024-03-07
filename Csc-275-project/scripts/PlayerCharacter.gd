extends RigidBody2D
@export var speed = 400;
var screen_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO;
	
	if Input.is_action_pressed("move-left") :
		velocity.x -= 1;
		
	if Input.is_action_pressed("move-right") :
		velocity.x += 1;
		
	if Input.is_action_pressed("jump") :
		velocity.y -= 1;
		
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed;
		
	position += velocity*delta;
	position = position.clamp(Vector2.ZERO, screen_size)
		
	if velocity.y >= 1:
		velocity -= 1;
