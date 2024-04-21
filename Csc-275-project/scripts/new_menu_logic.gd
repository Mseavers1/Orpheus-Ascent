extends Node2D

var is_over_start = false
var is_over_exit = false
var is_over_hwp = false
var is_over_credit = false
var is_over_back = false

func _process(delta):
	
	if Input.is_action_just_pressed("mouse-click"):
		
		# Start button is pressed
		if is_over_start:
			call_deferred("start_game")
			
		# Credit button is pressed
		if is_over_credit:
			show_credits()
			hide_buttons()
		
		# How-to-play button is pressed
		if is_over_hwp:
			hide_buttons()
			show_htp()
			
		# Exit button is pressed
		if is_over_exit:
			call_deferred("exit_game")
			
		# Back button is pressed
		if is_over_back:
			hide_htp()
			hide_credits()
			show_buttons()

func show_htp():
	$Canvas/HTP_Info.show()
	
func hide_htp():
	$Canvas/HTP_Info.hide()

func show_credits():
	$Canvas/Credit_Info.show()
	
func hide_credits():
	$Canvas/Credit_Info.hide()

func hide_buttons():
	$Canvas/Credits.hide()
	$Canvas/How_To_Play.hide()
	$Canvas/Exit_Button.hide()
	$Canvas/Start_Button.hide()
	$Canvas/Back_Button.show()

func show_buttons():
	$Canvas/Credits.show()
	$Canvas/How_To_Play.show()
	$Canvas/Exit_Button.show()
	$Canvas/Start_Button.show()
	$Canvas/Back_Button.hide()

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


func _on_mouse_entered_Back():
	is_over_back = true


func _on_mouse_exit_Back():
	is_over_back = false
