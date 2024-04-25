extends Control

var score_names
var score_values
var height_names
var height_values
var has_inputed_score = false

func _ready():
	
	Globals.load_new_scened()
	
	$Heights/Height_value.text = str(Globals.get_height()) + " m"
	$Scores/Score_value.text = str(Globals.get_score())
	
	score_names = [$Leaderboard_display/Scores/Score_1/Score1, $Leaderboard_display/Scores/Score_2/Score1, $Leaderboard_display/Scores/Score_3/Score1, $Leaderboard_display/Scores/Score_4/Score1, $Leaderboard_display/Scores/Score_5/Score1, $Leaderboard_display/Scores/Score_6/Score1, $Leaderboard_display/Scores/Score_7/Score1, $Leaderboard_display/Scores/Score_8/Score1, $Leaderboard_display/Scores/Score_9/Score1, $Leaderboard_display/Scores/Score_10/Score1]
	score_values = [$Leaderboard_display/Scores/Score_1/Value, $Leaderboard_display/Scores/Score_2/Value, $Leaderboard_display/Scores/Score_3/Value, $Leaderboard_display/Scores/Score_4/Value, $Leaderboard_display/Scores/Score_5/Value, $Leaderboard_display/Scores/Score_6/Value, $Leaderboard_display/Scores/Score_7/Value, $Leaderboard_display/Scores/Score_8/Value, $Leaderboard_display/Scores/Score_9/Value, $Leaderboard_display/Scores/Score_10/Value]
	
	height_names = [$Leaderboard_display/Heights/Score_1/Score1, $Leaderboard_display/Heights/Score_2/Score1, $Leaderboard_display/Heights/Score_3/Score1, $Leaderboard_display/Heights/Score_4/Score1, $Leaderboard_display/Heights/Score_5/Score1, $Leaderboard_display/Heights/Score_6/Score1, $Leaderboard_display/Heights/Score_7/Score1, $Leaderboard_display/Heights/Score_8/Score1, $Leaderboard_display/Heights/Score_9/Score1, $Leaderboard_display/Heights/Score_10/Score1]
	height_values = [$Leaderboard_display/Heights/Score_1/Value, $Leaderboard_display/Heights/Score_2/Value, $Leaderboard_display/Heights/Score_3/Value, $Leaderboard_display/Heights/Score_4/Value, $Leaderboard_display/Heights/Score_5/Value, $Leaderboard_display/Heights/Score_6/Value, $Leaderboard_display/Heights/Score_7/Value, $Leaderboard_display/Heights/Score_8/Value, $Leaderboard_display/Heights/Score_9/Value, $Leaderboard_display/Heights/Score_10/Value]
	
	start_loading()

func start_loading():
	clear_scores()
	$"Loading Stuff/Loading".show()
	$"Loading Stuff/Loading".play()
	call_deferred("refresh_leaderboard")
	
func finish_loading():
	$"Loading Stuff/Loading".stop()
	$"Loading Stuff/Loading".hide()

func refresh_leaderboard():
	
	# Get all players scores and heights
	var sw_result = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	var scores = sw_result.scores
	
	var sw_result2 = await SilentWolf.Scores.get_scores(0, "Height").sw_get_scores_complete
	var heights = sw_result2.scores
	
	# Display scores
	for i in range(10):
		
		if i > len(scores) - 1:
			score_names[i].text = "--"
			score_values[i].text = "--"
		else:
			score_names[i].text = str(scores[i]["player_name"]) + ":"
			score_values[i].text = str(scores[i]["score"])
		
		if i > len(heights) - 1:
			height_names[i].text = "--"
			height_values[i].text = "--"
		else:
			height_names[i].text = str(heights[i]["player_name"]) + ":"
			height_values[i].text = str(heights[i]["score"]) + " m"
			
	
	# Done loading
	finish_loading()
	
	

func to_game():
	get_tree().change_scene_to_file("res://scenes/TempScene.tscn")

func to_menu():
	get_tree().change_scene_to_file("res://scenes/New_menu.tscn")
	
func to_quit():
	get_tree().quit()

func _on_replay_pressed():
	call_deferred("to_game")


func _on_menu_pressed():
	call_deferred("to_menu")

func clear_scores():
		for i in range(10):
		
			score_names[i].text = "--"
			score_values[i].text = "--"
		
			height_names[i].text = "--"
			height_values[i].text = "--"

func _on_upload_score_pressed():
	if $Display_Name.text != "" && !has_inputed_score:
		SilentWolf.Scores.save_score($Display_Name.text, Globals.get_score())
		SilentWolf.Scores.save_score($Display_Name.text, Globals.get_height(), "Height")
		has_inputed_score = true
		start_loading()


func _on_refresh_pressed():
	start_loading()


func _on_quit_pressed():
	call_deferred("to_quit")
