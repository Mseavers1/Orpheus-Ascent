extends Node2D

var platform_size
var platform_pos
var has_pickup

func generate_platform(p_name, size, pos, marigins, pickup_spawned):
	platform_size = size
	platform_pos = pos
	has_pickup = pickup_spawned
	
	if !FileAccess.file_exists("res://images/platforms/" + p_name + ".png"):
		print("Unable to find the picture for the platform: " + str(p_name))
	
	var platform = load("res://images/platforms/" + p_name + ".png")
	
	$Platform.texture = platform
	$Area/Collider.shape = RectangleShape2D.new()
	$Area/Collider.shape.size = Vector2(size.x - marigins.x, size.y - marigins.y)
