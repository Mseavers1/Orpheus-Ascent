extends CanvasLayer

func _updateTurnDisplay(turn):
	$Turn_Display.text = turn + "\nTurn"
	
func _starting_score():
	$Top_Name/Top_Score.text = "0"
	$Bottom_Name/Bottom_Score.text = "0"
	
func _set_top_score(score):
	$Top_Name/Top_Score.text = str(score)

func _set_bottom_score(score):
	$Bottom_Name/Bottom_Score.text = str(score)
