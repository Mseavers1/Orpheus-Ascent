extends Sprite2D

@export var marblePrefab: PackedScene
const StartingMarblesInCells = 4

var visual_cells = [[[], []], [[], []], [[], []], [[], []], [[], []], [[], []]]
var cells

# Called at the start of the game to set up the starting board
func _setupBoard():
	cells = [[$Spawning_Area/Cell_0_0, $Spawning_Area/Cell_0_1], [$Spawning_Area/Cell_1_0, $Spawning_Area/Cell_1_1], [$Spawning_Area/Cell_2_0, $Spawning_Area/Cell_2_1], [$Spawning_Area/Cell_3_0, $Spawning_Area/Cell_3_1], [$Spawning_Area/Cell_4_0, $Spawning_Area/Cell_4_1], [$Spawning_Area/Cell_5_0, $Spawning_Area/Cell_5_1]]
	
	# Generate the starting marble count into each cell
	for x in range(6):
		for y in range(2):
			for num in range(StartingMarblesInCells):
				
				# Spawns a marble in the current cell at a random pos within its area
				var marble = marblePrefab.instantiate()
				marble.position = gen_random_pos(cells[x][y])
				
				# Adds marble to array, which can reference the marbles inside the cell at a later time
				visual_cells[x][y].push_back(marble)
				
				add_child(marble)

func gen_random_pos(area):
	
	# Find corners of area
	var center = area.position
	var topLeft = center - area.shape.extents
	var bottomRight = center + area.shape.extents
	
	# Generate rendom number between the top and bottom coords
	var x = randf_range(topLeft.x, bottomRight.x)
	var y = randf_range(topLeft.y, bottomRight.y)
	
	return Vector2(x, y)
	
func _move_marbles(x, y):
	var marbles = visual_cells[x][y]
	var next_cell = x - 1
	var cur_row = y
	
	for marble in marbles:
		
		# Move nth marble up
		var tween = create_tween()
		tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y - 50), 0.1).from(marble.position)
		
		await tween.finished
		tween.stop()
		
		# Move nth marble to the next cell
		tween = create_tween()
		tween.tween_property(marble, "position", Vector2(cells[next_cell][cur_row].position.x, marble.position.y), 0.1).from(marble.position)
		
		await tween.finished
		tween.stop()
		
		# Move nth marble to the down
		tween = create_tween()
		tween.tween_property(marble, "position", Vector2(marble.position.x, marble.position.y + 50), 0.1).from(marble.position)
		
		await tween.finished
		tween.stop()
		
		# Update nth cell with new marble
		visual_cells[next_cell][cur_row].push_back(marble)
		
		next_cell -= 1
		
		if (next_cell == -1):
			cur_row = 1
		
	
	visual_cells[x][y] = []
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

