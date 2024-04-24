extends Node2D

var currently_paused = false
var paused_forced = false

func _process(_delta):
	if Input.is_action_just_pressed("pause") and !paused_forced:
		pause_game()

func pause_game():
	currently_paused = !currently_paused
	get_tree().paused = currently_paused
	
	if currently_paused:
		$"Pause Menu".show()
	else:
		$"Pause Menu".hide()

func force_unpause():
	paused_forced = false
	get_tree().paused = false

func force_pause():
	paused_forced = true
	get_tree().paused = true
