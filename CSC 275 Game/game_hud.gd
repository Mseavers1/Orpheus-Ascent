extends CanvasLayer

func _updateTurnDisplay(turn):
	$Turn_Display.text = turn + "\nTurn"
