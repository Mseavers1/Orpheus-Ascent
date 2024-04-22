extends AnimatedSprite2D

var height = 1
var speed = 1
var timer = 0

var fireball = load("res://scenes/Fireball.tscn")
var chance_to_spawn = 0.7

# Called when the node enters the scene tree for the first time.
func _ready():
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	position.y -= sin(timer * speed) * height


func _on_fireball_timer_timeout():
	var rand = randf_range(0, 1)
	var spawn_chance = chance_to_spawn
	
	# Keep spawning fireballs until spawn_chance fails
	while true:
		
		rand = randf_range(0, 1)
		
		if rand <= spawn_chance:
			_summon_fireball()
			spawn_chance /= 2
		else:
			break
	


func _summon_fireball():
	var fireballObj = fireball.instantiate()
	
	var rand_alive = randf_range(3, 10)
	
	fireballObj._set_alive_timer(rand_alive)
	fireballObj.name = "Fireball"
	fireballObj.set_explosion_sound(-10)
	$"../Fireball_Holder".add_child(fireballObj)
	fireballObj.set_lava_pos_y(900)
	
	var randX = randf_range(25, 1894)
	var randY = randf_range(1080, 1080 + 100)
	
	fireballObj.speed = randf_range(80, 200)
	
	fireballObj.position = Vector2(randX, randY)
