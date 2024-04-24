extends Control

func _ready():
	
	get_tree().paused = false
	
	var sw_result = await SilentWolf.Scores.get_scores(0).sw_get_scores_complete
	var scores = sw_result.scores
	
	var sw_result2 = await SilentWolf.Scores.get_scores(0, "Height").sw_get_scores_complete
	var heights = sw_result2.scores
	
	var score_names = [$HBoxContainer/Scores/Score_1/Score1, $HBoxContainer/Scores/Score_2/Score1, $HBoxContainer/Scores/Score_3/Score1, $HBoxContainer/Scores/Score_4/Score1, $HBoxContainer/Scores/Score_5/Score1, $HBoxContainer/Scores/Score_6/Score1, $HBoxContainer/Scores/Score_7/Score1, $HBoxContainer/Scores/Score_8/Score1, $HBoxContainer/Scores/Score_9/Score1, $HBoxContainer/Scores/Score_10/Score1]
	var score_values = [$HBoxContainer/Scores/Score_1/Value, $HBoxContainer/Scores/Score_2/Value, $HBoxContainer/Scores/Score_3/Value, $HBoxContainer/Scores/Score_4/Value, $HBoxContainer/Scores/Score_5/Value, $HBoxContainer/Scores/Score_6/Value, $HBoxContainer/Scores/Score_7/Value, $HBoxContainer/Scores/Score_8/Value, $HBoxContainer/Scores/Score_9/Value, $HBoxContainer/Scores/Score_10/Value]
	
	var height_names = [$HBoxContainer/Heights/Score_1/Score1, $HBoxContainer/Heights/Score_2/Score1, $HBoxContainer/Heights/Score_3/Score1, $HBoxContainer/Heights/Score_4/Score1, $HBoxContainer/Heights/Score_5/Score1, $HBoxContainer/Heights/Score_6/Score1, $HBoxContainer/Heights/Score_7/Score1, $HBoxContainer/Heights/Score_8/Score1, $HBoxContainer/Heights/Score_9/Score1, $HBoxContainer/Heights/Score_10/Score1]
	var height_values = [$HBoxContainer/Heights/Score_1/Value, $HBoxContainer/Heights/Score_2/Value, $HBoxContainer/Heights/Score_3/Value, $HBoxContainer/Heights/Score_4/Value, $HBoxContainer/Heights/Score_5/Value, $HBoxContainer/Heights/Score_6/Value, $HBoxContainer/Heights/Score_7/Value, $HBoxContainer/Heights/Score_8/Value, $HBoxContainer/Heights/Score_9/Value, $HBoxContainer/Heights/Score_10/Value]
	
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
	

func to_game():
	get_tree().change_scene_to_file("res://scenes/TempScene.tscn")

func to_menu():
	get_tree().change_scene_to_file("res://scenes/New_menu.tscn")
	

func _on_replay_pressed():
	call_deferred("to_game")


func _on_menu_pressed():
	call_deferred("to_menu")
