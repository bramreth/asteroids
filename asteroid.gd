extends Node2D

onready var shape = get_node("asteroid/CollisionPolygon2D")
var tweak = 20
var speed = 5
var rot = 0
var hp = 2
var motion = Vector2(0,0)
var size
var pos
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	motion = Vector2((randi() % speed) - (speed/2), (randi() % speed) - (speed/2))
	$asteroid.linear_velocity = motion * 50
	print(shape)
	for i in range(shape.polygon.size()):
		shape.polygon[i] = size[i]
	position = pos

func setup(size_in, pos_in):
	size = size_in
	pos = pos_in
	
		

func _on_asteroid_body_entered(body):
	print(body.name)
	if body.name == "player":
		#end the game
		game_manager.damage_player()
	elif body.name == "shot":
		damage()
	elif body.name == "asteroid":
		#damage()
		pass

func damage():
	game_manager.add_score(1)
	queue_free()
		