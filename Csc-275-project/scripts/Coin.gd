extends StaticBody2D

var has_been_picked_up = false

func pickup(pitch):
	
	if has_been_picked_up:
		return
	
	$Coin_Pickup_Sound.pitch_scale = pitch
	$Coin_Pickup_Sound.play()
	$AnimatedSprite2D.play("pick_up")
	has_been_picked_up = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_animated_sprite_2d_animation_finished():
	if has_been_picked_up:
		queue_free()
