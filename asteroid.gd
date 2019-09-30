extends Node2D

onready var shape = get_node("asteroid/CollisionPolygon2D")
var tweak = 20
var speed = 5
var rot = 0
var hp = 2
var motion = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	motion = Vector2((randi() % speed) - (speed/2), (randi() % speed) - (speed/2))
	$asteroid.linear_velocity = motion * 50

func setup(size, pos):
	print(shape)
	for i in range(shape.polygon.size()):
		shape.polygon[i] = size[i]
	position = pos
		

func _on_asteroid_body_entered(body):
	print(body.name)
	if body.name == "player":
		#end the game
		get_tree().quit()
	elif body.name == "shot":
		damage()
	elif body.name == "asteroid":
		#damage()
		pass

func damage():
	queue_free()
		