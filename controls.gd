extends Node2D

var shot = preload("res://shot.tscn")
var spin = 0
var v = 0.0
var velocity = Vector2(0, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_left") and spin > -0.15:
		spin -= 0.01
	elif Input.is_action_pressed("ui_right") and spin < 0.15:
		spin += 0.01
	else:
		spin *= 0.9
	$player.rotate(spin)
	if Input.is_action_pressed("ui_up") and v < 2.0:
		v += 0.1
	else:
		v *= 0.9
	velocity = Vector2(v, 0).rotated($player.rotation) * 200.0
	velocity = $player.move_and_slide(velocity)
	
	if Input.is_action_just_pressed("ui_accept"):
		fire_weapon()
		
func fire_weapon():
	var instance = shot.instance()
	get_parent().add_child(instance)
	instance.spawn(Vector2(1.0, 0).rotated($player.rotation) * 15.0)
	instance.transform = $player/weapon.get_global_transform()

func set_limit(left, top, bottom, right):
	$player/Camera2D.limit_left = left
	$player/Camera2D.limit_right = right
	$player/Camera2D.limit_top = top
	$player/Camera2D.limit_bottom = bottom
	pass