extends Node2D

var platform_size
var platform_pos

func generate_platform(name, size, pos):
	platform_size = size
	platform_pos = pos
	
	var platform = load("res://images/platforms/" + name + ".png")
	$Platform.texture = platform
	$Area/Collider.shape = RectangleShape2D.new()
	$Area/Collider.shape.size = size
