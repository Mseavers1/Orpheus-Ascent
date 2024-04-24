extends Node

var current_score
var current_height

func set_score(v):
	current_score = v
	
func set_height(v):
	current_height = v

func get_score():
	return current_score

func get_height():
	return current_height

func _ready():
	SilentWolf.configure({
	"api_key": "3G6CrSINJuO9ZK99DzmO7NUyox8ii2f2WVrRLq6a",
	"game_id": "mynewgame",
	"log_level": 1
	})

	SilentWolf.configure_scores({
	"open_scene_on_close": "res://scenes/profile.tscn"
	})
	
	SilentWolf.configure_auth({
		"redirect_to_scene": "res://scenes/profile.tscn",
		"login_scene": "res://addons/silent_wolf/Auth/Login.tscn",
		"reset_password_scene": "res://addons/silent_wolf/Auth/ResetPassword.tscn",
		"session_duration_seconds": 0,
		"saved_session_expiration_days": 30
	})
