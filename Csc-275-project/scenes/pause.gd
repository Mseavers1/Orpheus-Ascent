extends Node2D

var currently_paused = false
var paused_forced = false

func _process(_delta):
	if Input.is_action_just_pressed("pause") and !paused_forced:
		pause_game()

func pause_game():
	currently_paused = !currently_paused
	get_tree().paused = currently_paused

func force_pause():
	paused_forced = true
	get_tree().paused = true
