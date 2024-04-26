extends Node

var current_score
var current_height
var setting_config = ConfigFile.new()

var is_using_meters = true

const setting_config_path = "res://saves/settings.cfg"
const default_audio = 0.6

func set_is_using_meters(v):
	is_using_meters = v

func is_units_meters():
	return is_using_meters

func load_new_scened():
	if get_tree().paused:
		get_tree().paused = false

func set_score(v):
	current_score = v
	
func set_height(v):
	current_height = v

func get_score():
	return current_score

func get_height():
	
	if is_using_meters:
		return ceil(current_height / 3.281)
	
	return current_height
	
func get_height_ft():
	return current_height

func save_audio():
	
	# Audio
	setting_config.set_value("Audio","master_audio", db_to_linear(AudioServer.get_bus_volume_db(0)))
	setting_config.set_value("Audio","music_audio", db_to_linear(AudioServer.get_bus_volume_db(1)))
	setting_config.set_value("Audio","sfx_audio", db_to_linear(AudioServer.get_bus_volume_db(2)))
	
	# Units
	setting_config.set_value("Units","is_meters", is_using_meters)
	
	setting_config.save(setting_config_path)

func _ready():
	
	# Set Audio buffers at start of game
	var err = setting_config.load(setting_config_path) 
	if err == OK: 
		AudioServer.set_bus_volume_db(0, linear_to_db(setting_config.get_value("Audio", "master_audio")))
		AudioServer.set_bus_volume_db(1, linear_to_db(setting_config.get_value("Audio", "music_audio")))
		AudioServer.set_bus_volume_db(2, linear_to_db(setting_config.get_value("Audio", "sfx_audio")))
		is_using_meters = setting_config.get_value("Units", "is_meters")
	else:
		setting_config.set_value("Audio","master_audio", default_audio)
		setting_config.set_value("Audio","music_audio", default_audio)
		setting_config.set_value("Audio","sfx_audio", default_audio)
		setting_config.set_value("Units","is_meters", is_using_meters)
		
		setting_config.save(setting_config_path)
		
		AudioServer.set_bus_volume_db(0, linear_to_db(default_audio))
		AudioServer.set_bus_volume_db(1, linear_to_db(default_audio))
		AudioServer.set_bus_volume_db(2, linear_to_db(default_audio))
	
	# Silent Wolf Startup stuff
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
