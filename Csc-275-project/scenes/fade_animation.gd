extends AnimatedSprite2D

func start_fade():
	modulate.a = 0.8
	$Fade_timer.start()
	
	

func _on_fade_timer_timeout():
	modulate.a -= 0.02
	
	if modulate.a <= 0.01:
		$Fade_timer.stop()
		hide()
