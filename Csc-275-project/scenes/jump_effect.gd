extends Node2D

func play_jump():
	$Animator.play("Jump")

func play_double():
	$Animator.play("Double_Jump")


func _on_animator_animation_finished():
	queue_free()
