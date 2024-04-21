extends AnimatedSprite2D

@export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	play("moving")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= speed * delta

# Collision with player
func _on_body_entered(body):
	print(body.name)

# Collision with platform
func _on_area_entered(area):
	speed = 0
	play("explode")


func _on_animation_finished():
	queue_free()

# Ensures that fireballs despawn after a certain amount of time passes
func _on_alive_timer_timeout():
	speed = 0
	play("explode")
