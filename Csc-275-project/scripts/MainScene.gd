extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	

# This is called when the user clicks to start the game
func _on_main_menu_game_start_button_pressed():
	print('game started');


func _on_main_menu_credits_button_pressed():
	print('Main scene knows credits button has been pressed');


func _on_main_menu_exit_button_pressed():
	print('Main scene knows the exit button was pressed');
