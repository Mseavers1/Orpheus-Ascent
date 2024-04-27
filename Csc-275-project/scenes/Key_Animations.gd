extends Node2D

var current_page = 0
var max_pages

var animations = ["movement", ""]

var w
var s
var a
var d

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
	
	w = $WASD/Up_1
	s = $WASD/Down_1
	a = $WASD/Left_1
	d = $WASD/Right_1
	
	up = $Arrow_Keys/Up_1
	down = $Arrow_Keys/Down_1
	left = $Arrow_Keys/Left_1
	right = $Arrow_Keys/Right_1

func movement_animations(frame):
	if frame <= 7:
			w.play("W_None")
			s.play("S_None")
			a.play("A_None")
			d.play("D_Select")
			
			up.play("Up_None")
			down.play("Down_None")
			left.play("Left_None")
			right.play("Right_Select")
	elif frame > 7 and frame < 11:
		w.play("W_None")
		s.play("S_None")
		a.play("A_None")
		d.play("D_None")
		
		up.play("Up_None")
		down.play("Down_None")
		left.play("Left_None")
		right.play("Right_None")
	else:
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

func _on_new_menu_clicked_next():
	
	if current_page <= 0:
		$Prev.show()
	
	current_page += 1
	#all_start(animations[current_page])
	print(animations[current_page])
	
	if current_page >= max_pages:
		$Next.hide()


func _on_new_menu_clicked_prev():
	
	if current_page >= max_pages:
		$Next.show()
	
	current_page -= 1
	print(animations[current_page])
	
	if current_page <= 0:
		$Prev.hide()
