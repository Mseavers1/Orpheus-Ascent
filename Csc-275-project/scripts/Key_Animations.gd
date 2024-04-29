extends Node2D

var current_page = 0
var max_pages

var infos

var w
var s
var a
var d

var space
var escape
var e

var up
var down
var left
var right

func all_stop():
	pass

func all_start():
	
	infos[current_page].show()
	animate()
	
	var counter = 0
	for info in infos:
		
		if current_page != counter:
			info.hide()
		
		counter += 1
	
	
func returned():
	all_start()

func _ready():
	
	infos = [$Labels/Movement, $Labels/Jump_1, $Labels/Jump_2, $Labels/Jump_3, $Labels/Dashing_1, $Labels/Dashing_2, $Labels/Dashing_3, $Labels/Dashing_4, $Labels/Pauses, $Labels/Coins_1, $Labels/Coins_2, $Labels/Points, $Labels/Fireballs, $Labels/Lava, $Labels/Leaderboard, $Labels/Last]
	
	max_pages = len(infos) - 1
	
	space = $Other_Keys/Space_bar
	escape = $Other_Keys/Escape_key
	e = $Other_Keys/E_Key
	
	w = $WASD/Up_1
	s = $WASD/Down_1
	a = $WASD/Left_1
	d = $WASD/Right_1
	
	up = $Arrow_Keys/Up_1
	down = $Arrow_Keys/Down_1
	left = $Arrow_Keys/Left_1
	right = $Arrow_Keys/Right_1

func animate():
	if current_page == 0:
		w.stop()
		s.stop()
		a.play("A")
		d.play("D")
		
		up.stop()
		down.stop()
		left.play("Left")
		right.play("Right")
		
		space.stop()
		escape.stop()
		e.stop()
		
	elif current_page == 1:
		w.play("W")
		s.stop()
		a.stop()
		d.stop()
		
		up.play("Up")
		down.stop()
		left.stop()
		right.stop()
		
		space.play("Space")
		escape.stop()
		e.stop()
	elif current_page == 2:
		w.play("W_Hold")
		s.stop()
		a.stop()
		d.stop()
		
		up.play("Up_Hold")
		down.stop()
		left.stop()
		right.stop()
		
		space.play("Space_Hold")
		escape.stop()
		e.stop()
	elif current_page == 3:
		w.play("W_Double")
		s.stop()
		a.stop()
		d.stop()
		
		up.play("Up_Double")
		down.stop()
		left.stop()
		right.stop()
		
		space.play("Space_Double")
		escape.stop()
		e.stop()
	elif current_page == 4:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.play("E")
	elif current_page == 5:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.play("E")
	elif current_page == 6:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.play("E")
	elif current_page == 7:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.play("E")
	elif current_page == 8:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.play("ESC")
		e.stop()
	elif current_page == 9:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.stop()
	elif current_page == 10:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.stop()
	elif current_page == 11:
		w.stop()
		s.stop()
		a.stop()
		d.stop()
		
		up.stop()
		down.stop()
		left.stop()
		right.stop()
		
		space.stop()
		escape.stop()
		e.stop()

func _on_new_menu_clicked_next():
	
	$"../../Select_Sound".play()
	
	if current_page <= 0:
		$Prev.show()
	
	current_page += 1
	all_start()
	
	if current_page >= max_pages:
		$Next.hide()


func _on_new_menu_clicked_prev():
	
	$"../../Select_Sound".play()
	
	if current_page >= max_pages:
		$Next.show()
	
	current_page -= 1
	all_start()
	
	if current_page <= 0:
		$Prev.hide()
