extends Node

var current_score
var current_height
var setting_config = ConfigFile.new()

const setting_config_path = "res://saves/settings.cfg"
const default_audio = 0.6

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
	return current_height

func save_audio():
	setting_config.set_value("Audio","master_audio", db_to_linear(AudioServer.get_bus_volume_db(0)))
	setting_config.set_value("Audio","music_audio", db_to_linear(AudioServer.get_bus_volume_db(1)))
	setting_config.set_value("Audio","sfx_audio", db_to_linear(AudioServer.get_bus_volume_db(2)))
	
	setting_config.save(setting_config_path)

func _ready():
	
	# Set Audio buffers at start of game
	var err = setting_config.load(setting_config_path) 
	if err == OK: 
		## Make sure there is only one section in config
		# if you add more, than this will need to be readjusted
		for section in setting_config.get_sections():
			AudioServer.set_bus_volume_db(0, linear_to_db(setting_config.get_value(section, "master_audio")))
			AudioServer.set_bus_volume_db(1, linear_to_db(setting_config.get_value(section, "music_audio")))
			AudioServer.set_bus_volume_db(2, linear_to_db(setting_config.get_value(section, "sfx_audio")))
	else:
		setting_config.set_value("Audio","master_audio", default_audio)
		setting_config.set_value("Audio","music_audio", default_audio)
		setting_config.set_value("Audio","sfx_audio", default_audio)
		
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
