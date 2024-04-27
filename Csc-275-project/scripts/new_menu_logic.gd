extends Node2D

const hovering_scale = 1.2

var is_over_start = false
var is_over_exit = false
var is_over_hwp = false
var is_over_credit = false
var is_over_back = false
var is_over_setting = false
var is_over_prev = false
var is_over_next = false

signal clicked_next
signal clicked_prev

func _ready():
	Globals.load_new_scened()
	
	$Canvas/Setting_info/Volume/Master/Master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Canvas/Setting_info/Volume/Music/music_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Canvas/Setting_info/Volume/SFX/Sound_Slider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _process(delta):
	
	if Input.is_action_just_pressed("mouse-click"):
		
		# Next button is pressed
		if is_over_next:
			clicked_next.emit()
			
		# Prev button is pressed
		if is_over_prev:
			clicked_prev.emit()
		
		# Setting button is pressed
		if is_over_setting:
			$Select_Sound.play()
			hide_buttons()
			show_setting()
		
		# Start button is pressed
		if is_over_start:
			call_deferred("start_game")
			
		# Credit button is pressed
		if is_over_credit:
			$Select_Sound.play()
			show_credits()
			hide_buttons()
		
		# How-to-play button is pressed
		if is_over_hwp:
			$Select_Sound.play()
			hide_buttons()
			show_htp()
			
		# Exit button is pressed
		if is_over_exit:
			call_deferred("exit_game")
			
		# Back button is pressed
		if is_over_back:
			$Select_Sound.play()
			hide_htp()
			hide_credits()
			hide_setting()
			show_buttons()

func show_setting():
	$Canvas/Setting_info.show()
	
func hide_setting():
	$Canvas/Setting_info.hide()

func show_htp():
	$Canvas/HTP_Info.show()
	$Canvas/HTP_Info.all_start("movement")
	
func hide_htp():
	$Canvas/HTP_Info.hide()
	$Canvas/HTP_Info.all_stop()

func show_credits():
	$Canvas/Credit_Info.show()
	
func hide_credits():
	$Canvas/Credit_Info.hide()

func hide_buttons():
	$Canvas/Credits.hide()
	$Canvas/How_To_Play.hide()
	$Canvas/Exit_Button.hide()
	$Canvas/Start_Button.hide()
	$Canvas/Settings_Button.hide()
	$Canvas/Back_Button.show()

func show_buttons():
	$Canvas/Credits.show()
	$Canvas/How_To_Play.show()
	$Canvas/Exit_Button.show()
	$Canvas/Start_Button.show()
	$Canvas/Settings_Button.show()
	$Canvas/Back_Button.hide()

func exit_game():
	get_tree().quit()

func start_game():
	get_tree().change_scene_to_file("res://scenes/TempScene.tscn")

func _on_mouse_enter_Start():
	is_over_start = true
	$Canvas/Start_Button.scale = Vector2(hovering_scale, hovering_scale)

func _on_mouse_exit_Start():
	is_over_start = false
	$Canvas/Start_Button.scale = Vector2(1, 1)

func _on_mouse_entered_Exit():
	is_over_exit = true
	$Canvas/Exit_Button.scale = Vector2(hovering_scale, hovering_scale)

func _on_mouse_exit_Exit():
	is_over_exit = false
	$Canvas/Exit_Button.scale = Vector2(1, 1)

func _on_mouse_entered_HTP():
	is_over_hwp = true
	$Canvas/How_To_Play.scale = Vector2(hovering_scale, hovering_scale)

func _on_mouse_exit_HTP():
	is_over_hwp = false
	$Canvas/How_To_Play.scale = Vector2(1, 1)

func _on_mouse_entered_Credits():
	is_over_credit = true
	$Canvas/Credits.scale = Vector2(hovering_scale, hovering_scale)

func _on_mouse_exit_Credits():
	is_over_credit = false
	$Canvas/Credits.scale = Vector2(1, 1)


func _on_mouse_entered_Back():
	is_over_back = true
	$Canvas/Back_Button.scale = Vector2(hovering_scale, hovering_scale)


func _on_mouse_exit_Back():
	is_over_back = false
	$Canvas/Back_Button.scale = Vector2(1, 1)


func _on_mouse_entered_settings():
	is_over_setting = true
	$Canvas/Settings_Button.scale = Vector2(hovering_scale, hovering_scale)


func _on_mouse_exit_Settings():
	is_over_setting = false
	$Canvas/Settings_Button.scale = Vector2(1, 1)


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	AudioServer.set_bus_mute(0, value < 0.01)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	AudioServer.set_bus_mute(1, value < 0.01)


func _on_sound_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	AudioServer.set_bus_mute(2, value < 0.01)


func _on_tree_exiting():
	Globals.save_audio()


func _on_mouse_enter_Next():
	is_over_next = true
	$Canvas/HTP_Info/Next.scale = Vector2(hovering_scale, hovering_scale)


func _on_mouse_exit_Next():
	is_over_next = false
	$Canvas/HTP_Info/Next.scale = Vector2(1, 1)

func _on_mouse_entered_Prev():
	is_over_prev = true
	$Canvas/HTP_Info/Prev.scale = Vector2(hovering_scale, hovering_scale)


func _on_mouse_exit_Prev():
	is_over_prev = false
	$Canvas/HTP_Info/Prev.scale = Vector2(1, 1)
