extends Sprite2D

@export var marblePrefab: PackedScene
const StartingMarblesInCells = 4

var cells

func _setupBoard():
	cells = [[$Area/Cell_0_0, $Area/Cell_0_1], [$Area/Cell_1_0, $Area/Cell_1_1], [$Area/Cell_2_0, $Area/Cell_2_1], [$Area/Cell_3_0, $Area/Cell_3_1], [$Area/Cell_4_0, $Area/Cell_4_1], [$Area/Cell_5_0, $Area/Cell_5_1]]
	
	# Generate the starting marble count into each cell
	for x in range(6):
		for y in range(2):
			for num in range(StartingMarblesInCells):
				var marble = marblePrefab.instantiate()
				marble.position = gen_random_pos(cells[x][y])
				
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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
