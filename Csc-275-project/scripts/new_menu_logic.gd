extends Node2D

var is_over_start = false
var is_over_exit = false
var is_over_hwp = false
var is_over_credit = false

func _process(delta):
	
	if Input.is_action_just_pressed("mouse-click"):
		
		# Start button is pressed
		if is_over_start:
			call_deferred("start_game")
			
		# Credit button is pressed
		if is_over_credit:
			print("credit")
		
		# How-to-play button is pressed
		if is_over_hwp:
			print("How to play")
			
		# Exit button is pressed
		if is_over_exit:
			call_deferred("exit_game")

func exit_game():
	get_tree().quit()

func start_game():
	get_tree().change_scene_to_file("res://.godot/exported/133200997/export-dcaaea05617b0915188f8bfcd125ecc1-TempScene.scn")

func _on_mouse_enter_Start():
	is_over_start = true

func _on_mouse_exit_Start():
	is_over_start = false

func _on_mouse_entered_Exit():
	is_over_exit = true

func _on_mouse_exit_Exit():
	is_over_exit = false

func _on_mouse_entered_HTP():
	is_over_hwp = true

func _on_mouse_exit_HTP():
	is_over_hwp = false

func _on_mouse_entered_Credits():
	is_over_credit = true

func _on_mouse_exit_Credits():
	is_over_credit = false
