extends Node2D

var w
var s
var a
var d

var up
var down
var left
var right

func _ready():
	w = $Up_1
	s = $Down_1
	a = $Left_1
	d = $Right_1
	
	up = $"../Arrow_Keys/Up_1"
	down = $"../Arrow_Keys/Down_1"
	left = $"../Arrow_Keys/Left_1"
	right = $"../Arrow_Keys/Right_1"

func _on_vidoe_player_gif_frame_changed():
	var frame = $"../vidoe_player_gif".frame
	
	if frame <= 7:
		w.play("W_None")
		s.play("S_None")
		a.play("A_None")
		d.play("D_Select")
	elif frame > 7 and frame < 11:
		w.play("W_None")
		s.play("S_None")
		a.play("A_None")
		d.play("D_None")
	else:
		w.play("W_None")
		s.play("S_None")
		a.play("A_Select")
		d.play("D_None")
