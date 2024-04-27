extends Node2D

var current_page = 0
var max_pages

var animations = ["movement", "jumping"]

var w
var s
var a
var d

var space
var escape

var up
var down
var left
var right

func all_stop():
	$vidoe_player_gif.stop()

func all_start(n):
	
	$vidoe_player_gif.play(n)

func _ready():
	
	max_pages = len(animations) - 1
	
	space = $Other_Keys/Space_bar
	escape = $Other_Keys/Escape_key
	
	w = $WASD/Up_1
	s = $WASD/Down_1
	a = $WASD/Left_1
	d = $WASD/Right_1
	
	up = $Arrow_Keys/Up_1
	down = $Arrow_Keys/Down_1
	left = $Arrow_Keys/Left_1
	right = $Arrow_Keys/Right_1

func jumping_animation(frame):
	if frame > 0 and frame <= 4:
			space.play("Space_Select")
			escape.play("Escape_None")
		
			w.play("W_Select")
			s.play("S_None")
			a.play("A_None")
			d.play("D_None")
			
			up.play("Up_Select")
			down.play("Down_None")
			left.play("Left_None")
			right.play("Right_None")
	elif frame > 5 and frame < 8:
		
		space.play("Space_Select")
		escape.play("Escape_None")
		
		w.play("W_Select")
		s.play("S_None")
		a.play("A_None")
		d.play("D_None")
		
		up.play("Up_Select")
		down.play("Down_None")
		left.play("Left_None")
		right.play("Right_None")
	else:
		
		space.play("Space_None")
		escape.play("Escape_None")
		
		w.play("W_None")
		s.play("S_None")
		a.play("A_None")
		d.play("D_None")
		
		up.play("Up_None")
		down.play("Down_None")
		left.play("Left_None")
		right.play("Right_None")

func movement_animations(frame):
	if frame <= 7:
			space.play("Space_None")
			escape.play("Escape_None")
			
			w.play("W_None")
			s.play("S_None")
			a.play("A_None")
			d.play("D_Select")
			
			up.play("Up_None")
			down.play("Down_None")
			left.play("Left_None")
			right.play("Right_Select")
	elif frame > 7 and frame < 11:
		
		space.play("Space_None")
		escape.play("Escape_None")
		
		w.play("W_None")
		s.play("S_None")
		a.play("A_None")
		d.play("D_None")
		
		up.play("Up_None")
		down.play("Down_None")
		left.play("Left_None")
		right.play("Right_None")
	else:
		
		space.play("Space_None")
		escape.play("Escape_None")
		
		w.play("W_None")
		s.play("S_None")
		a.play("A_Select")
		d.play("D_None")
		
		up.play("Up_None")
		down.play("Down_None")
		left.play("Left_Select")
		right.play("Right_None")

func _on_vidoe_player_gif_frame_changed():
	var frame = $vidoe_player_gif.frame
	var type = $vidoe_player_gif.animation
	
	if type == "movement":
		movement_animations(frame)
	elif type == "jumping":
		jumping_animation(frame)

func _on_new_menu_clicked_next():
	
	if current_page <= 0:
		$Prev.show()
	
	current_page += 1
	all_start(animations[current_page])
	
	if current_page >= max_pages:
		$Next.hide()


func _on_new_menu_clicked_prev():
	
	if current_page >= max_pages:
		$Next.show()
	
	current_page -= 1
	all_start(animations[current_page])
	
	if current_page <= 0:
		$Prev.hide()
