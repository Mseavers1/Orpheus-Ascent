extends CanvasLayer

var strings = ["3", "2", "1", "Ascend!!!"]
var index = 0

signal start_of_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$counting_label.text = strings[index]
	$Countdown.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_countdown_timeout():
	if index < len(strings):
		
		# Last index
		if index == len(strings) - 1:
			$counting_label.hide()
			return
			
		# Second to last index
		if index == len(strings) - 2:
			start_of_game.emit()
		
		index += 1
		$counting_label.text = strings[index]
		$Countdown.start()
