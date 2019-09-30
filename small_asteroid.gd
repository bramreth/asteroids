extends Node2D

onready var shape = get_node("asteroid/CollisionPolygon2D")
var sml = preload("res://small_asteroid.tscn")
var tweak = 20
var speed = 5
var rot = 0
var hp = 2
var motion = Vector2(0,0)
var i1 = sml.instance()
var i2 = sml.instance()
signal build_split(i1, i2, position)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomize()
	var new_size = []
	for item in shape.polygon:
		item.x += (randi() % tweak) - (tweak/2)
		item.y += (randi() % tweak) - (tweak/2)
		new_size.append(Vector2(item.x, item.y))
	shape.polygon = new_size
	motion = Vector2((randi() % speed) - (speed/2), (randi() % speed) - (speed/2))
	rot = (randf()/10.0) - 0.05
	$asteroid.linear_velocity = motion * 100
	$asteroid.rotation = rot
	$asteroid.mass = randi()%5
	
func map_extents(t,b,l,r):
#	if $asteroid/CollisionPolygon2D.position
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	translate(motion)

	var ax = $asteroid.get_global_transform().origin.x
	var ay = $asteroid.get_global_transform().origin.y
	if ax > 600 or ay > 600 or ax < -600 or ay < -600:
		queue_free()
#	rotate(rot)

#lifespan
func _on_Timer_timeout():
#	queue_free()
	pass
#collision with asteroid
#func _on_Area2D_area_entered(area):
#	print(area.get_name())
#	if area.get_name() == "asteroid":
#		motion = -motion
#	else:
#		queue_free()

#collision with physics object
func _on_Area2D_body_entered(body):
	queue_free()



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
	hp -= 1
	if hp <= 0:
		split()
		queue_free()
	elif hp == 1:
		$asteroid.modulate = Color(1,0,1,1)
		
# create two new smaller asteroids.
func split():
	print(shape.polygon)
	var it = []
	var jt = []
	var counter = 0
	for i in shape.polygon:
		if counter <= (shape.polygon.size()/2)+1:
			it.append(i)
		if counter >= (shape.polygon.size()/2)-1:
			jt.append(i)
		
		counter += 1
	print(it, jt)
	
	get_parent().add_child(i1)
	get_parent().add_child(i2)
	
	i1.setup(it, $asteroid.get_global_transform().origin)
	i2.setup(jt, $asteroid.get_global_transform().origin)
			