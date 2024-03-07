extends CanvasLayer
signal game_start_button_pressed;
signal credits_button_pressed;
signal exit_button_pressed;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_start_button_pressed():
	$CanvasGroup/GameStartButton.hide();
	$CanvasGroup/CreditsButton.hide();
	$CanvasGroup/ExitButton.hide();
	$Background.hide();
	$Title.hide();
	game_start_button_pressed.emit();


func _on_credits_button_pressed():
	print('credits button pressed');
	$CanvasGroup/GameStartButton.hide();
	$CanvasGroup/CreditsButton.hide();
	$CanvasGroup/ExitButton.hide();
	$Title.hide();
	credits_button_pressed.emit();

func _on_exit_button_pressed():
	print('Exit button pressed');
	$CanvasGroup/GameStartButton.hide();
	$CanvasGroup/CreditsButton.hide();
	$CanvasGroup/ExitButton.hide();
	$Title.hide();
	exit_button_pressed.emit();
