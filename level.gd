extends Node2D

var asteroid = preload("res://asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Node2D.set_limit(-500, -500, 500, 500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# spawn an enemy
func _on_Timer_timeout():
	var instance = asteroid.instance()
	add_child(instance)
	
	#if left
	print(instance.motion)
	var x_spawn = 0
	var y_spawn = 0
	randomize()
	if randi()%2:
		if instance.motion.x > 0:
			x_spawn = - 500
		else:
			x_spawn = 500
		if instance.motion.y > 0:
			y_spawn = randi() % 500 - 500
		else:
			y_spawn = randi() % 500
	else:
		if instance.motion.y > 0:
			y_spawn = - 500
			pass
		else:
			y_spawn = 500
		if instance.motion.x > 0:
			x_spawn = randi() % 500 
		else:
			x_spawn = randi() % 500 - 500
	instance.position = Vector2(x_spawn, y_spawn)
