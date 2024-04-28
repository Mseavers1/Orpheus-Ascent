extends Control

@export var data_label: Label
@export var login_info: Label

@export var highest_score: Label
@export var highest_height: Label
@export var name_label: Label

@export var current_score: Label
@export var current_height: Label

var user_name
var user_height
var user_score

func _ready():
	
	get_tree().paused = false
	
	current_score.text = str(Globals.get_score())
	current_height.text = str(Globals.get_height())
	
	SilentWolf.Auth.sw_session_check_complete.connect(_on_login_complete)
	SilentWolf.Auth.sw_login_complete.connect(_on_login_complete)
	SilentWolf.Auth.sw_logout_complete.connect(_on_logout_complete)
	
	SilentWolf.Auth.auto_login_player()

func _on_register_but_pressed():
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Register.tscn")


func _on_login_but_pressed():
	get_tree().change_scene_to_file("res://addons/silent_wolf/Auth/Login.tscn")


func _on_logout_but_pressed():
	SilentWolf.Auth.logout_player()
	
func _on_logout_complete(a, b):
	update_login_state_label()
		
func _on_login_complete(sw_result):
	update_login_state_label()
	
	# Load data once logged in
	if SilentWolf.Auth.logged_in_player:
		load_data()
		
func update_login_state_label():
	if SilentWolf.Auth.logged_in_player:
		login_info.text = "Logged in"
	else:
		login_info.text = "Not logged in"

func load_data():
	if SilentWolf.Auth.logged_in_player:
		data_label.text = "Loading"
		
		# load data async
		var sw_result = await SilentWolf.Players.get_player_data(SilentWolf.Auth.logged_in_player).sw_get_player_data_complete
		print("Player data: " + str(sw_result.player_data))
		
		# show load result on data_label
		if sw_result and sw_result.success and sw_result.player_data:
			data_label.text = "Load Success"
			
			user_name = SilentWolf.Auth.logged_in_player
			
			if "Height" in sw_result.player_data.keys():
				user_height = sw_result.player_data["Height"]
			else:
				user_height = 0
			
			if "Score" in sw_result.player_data.keys():
				user_score = sw_result.player_data["Score"]
			else:
				user_score = 0
				
			update_scores()
			
		else:
			data_label.text = "Load failed"

func update_scores():
	highest_score.text = str(user_score)
	name_label.text = str(user_name)
	highest_height.text = str(user_height)
	
func update_scores_new():
	highest_score.text = str(Globals.get_score())
	highest_height.text = str(Globals.get_height())

func _on_save_button_pressed():
	var player_data: Dictionary = {}
	var fail = false
	
	if highest_score.text != "0":
		player_data["Score"] = current_score.text
	else:
		fail = true
		
	if highest_score.text != "0":
		player_data["Height"] = current_height.text
	else:
		fail = true
		
	if fail:
		data_label.text = "No 0 values"
	else:
		save_data(player_data)
		
func save_data(player_data: Dictionary):
	if SilentWolf.Auth.logged_in_player:
		data_label.text = "Saving"
		var sw_result = await SilentWolf.Players.save_player_data(SilentWolf.Auth.logged_in_player, player_data).sw_save_player_data_complete
		data_label.text = "Save success" if sw_result and sw_result.success else "Save failed"
		update_scores_new()
		SilentWolf.Scores.save_score(user_name, Globals.get_score())
		SilentWolf.Scores.save_score(user_name, Globals.get_height(), "Height")

func to_game():
	get_tree().change_scene_to_file("res://scenes/TempScene.tscn")

func to_menu():
	get_tree().change_scene_to_file("res://scenes/New_menu.tscn")

func _on_replay_pressed():
	logout()
	call_deferred("to_game")


func _on_menu_pressed():
	logout()
	call_deferred("to_menu")

func logout():
	SilentWolf.Auth.logout_player()
