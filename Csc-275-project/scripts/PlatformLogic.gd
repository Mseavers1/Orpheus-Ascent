extends Node2D

var platform_size
var platform_pos
var has_pickup

func generate_platform(name, size, pos, marigins, pickup_spawned):
	platform_size = size
	platform_pos = pos
	has_pickup = pickup_spawned
	
	if !FileAccess.file_exists("res://images/platforms/" + name + ".png"):
		print("Unable to find the picture for the platform: " + str(name))
	
	var platform = load("res://images/platforms/" + name + ".png")
	
	$Platform.texture = platform
	$Area/Collider.shape = RectangleShape2D.new()
	$Area/Collider.shape.size = Vector2(size.x - marigins.x, size.y - marigins.y)
