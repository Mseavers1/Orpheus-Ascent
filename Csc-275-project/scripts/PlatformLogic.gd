extends Node2D

var platform_size
var platform_pos

func generate_platform(name, size, pos):
	platform_size = size
	platform_pos = pos
	
	if !FileAccess.file_exists("res://images/platforms/" + name + ".png"):
		print("Unable to find the picture for the platform: " + str(name))
	
	var platform = load("res://images/platforms/" + name + ".png")
	
	$Platform.texture = platform
	$Area/Collider.shape = RectangleShape2D.new()
	$Area/Collider.shape.size = size
