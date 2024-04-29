extends Node2D

var infos
var current_page = 0
var max_pages

# Called when the node enters the scene tree for the first time.
func _ready():
	infos = [$Labels/Team, $Labels/Music_1, $Labels/Music_2, $Labels/Sounds_1, $Labels/Sounds_2, $Labels/Sounds_3, $Labels/Player, $Labels/Platforms, $Labels/Lava, $Labels/Fireball]
	max_pages = len(infos) - 1
	
	all_start()
	
func all_start():
	
	infos[current_page].show()
	
	var counter = 0
	for info in infos:
		
		if current_page != counter:
			info.hide()
		
		counter += 1


func _on_new_menu_clicked_next_credit():
	
	$"../../Select_Sound".play()
	
	if current_page <= 0:
		$Prev.show()
	
	current_page += 1
	all_start()
	
	if current_page >= max_pages:
		$Next.hide()


func _on_new_menu_clicked_prev_credits():
	
	$"../../Select_Sound".play()
	
	if current_page >= max_pages:
		$Next.show()

	current_page -= 1
	all_start()

	if current_page <= 0:
		$Prev.hide()
