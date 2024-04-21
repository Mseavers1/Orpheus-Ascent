extends AnimatedSprite2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	play("moving")

func _set_alive_timer(time):
	$AliveTimer.wait_time = time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta

# Collision with platform
func _on_body_entered(body):
	speed = 0
	play("explode")

# Collision with platform
func _on_area_entered(_area):
	
	# Doesn't collide with buttons when they are hidden
	if !_area.get_parent().is_visible():
		return
	
	speed = 0
	play("explode")


func _on_animation_finished():
	queue_free()

# Ensures that fireballs despawn after a certain amount of time passes
func _on_alive_timer_timeout():
	speed = 0
	play("explode")
