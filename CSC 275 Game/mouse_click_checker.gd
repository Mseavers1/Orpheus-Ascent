extends Area2D

var is_following_mouse = true
var cells_over = [[false, false], [false, false], [false, false], [false, false], [false, false], [false, false]]

func _set_follow(follow):
	is_following_mouse = follow

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_following_mouse:
		position = get_viewport().get_mouse_position()
		
	if Input.is_action_just_released("Mouse_Click"):
		var coords = _get_current_cell_coords_of_turn()
		
		# No mouse is currently selected in the section of the current turn (top or bottom)
		if (coords == Vector2(-1, -1)):
			return
			
		# Move Piece based on selection
		# TODO = If ai turn, move automatically
		if coords.y == 0:
			get_parent()._movePieceTop(coords.x)
		else:
			get_parent()._movePieceBottom(coords.x)
			
		print(get_parent().board)
		
# Returns the cell that is currently selected of a certain row (whoever turn / Top or Bottom)
func _get_current_cell_coords_of_turn():
	var turn = get_parent().currentTurn
	
	for x in range(6):
		if cells_over[x][turn]:
			return Vector2(x, turn)
			
	return Vector2(-1, -1)
		
# Returns the cell that is currently selected (mouse is hovering)
func _get_current_cell_coords():	
	for x in range(6):
		for y in range(2):
			if cells_over[x][y]:
				return Vector2(x, y)
	

# Update the cell_over array whenever the mouse hover over a cell
func _check_over(area, is_over):
	var split = area.name.split('_')
	
	if (split[0] == "Cell"):
		var x = int(split[1])
		var y = int(split[2])
		
		cells_over[x][y] = is_over

func _on_area_entered(area):
	_check_over(area, true)

func _on_area_exited(area):
	_check_over(area, false)
