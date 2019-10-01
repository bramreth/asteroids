extends Node2D

var shot = preload("res://shot.tscn")
var spin = 0
var v = 0.0
var acc = 0.1
var velocity = Vector2(0, 0)
var speed = 200
var max_v = 2.0
var r_acc = 0.01
var max_r = 0.15
var drag = 0.9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# handle rotation
	if Input.is_action_pressed("ui_left"):
		rotate_left()
	elif Input.is_action_pressed("ui_right"):
		rotate_right()
	else:
		spin *= drag
		
	$player.rotate(spin)
	
	# handle thrust
	if Input.is_action_pressed("ui_up"):
		thrust()
	else:
		v *= drag
	velocity = Vector2(v, 0).rotated($player.rotation) * speed
	velocity = $player.move_and_slide(velocity)
	
	# handle shooting
	if Input.is_action_just_pressed("ui_accept"):
		fire_weapon()

func thrust():
	if v < max_v:
		v += acc

func rotate_left():
	if abs(spin) < max_r:
		spin -= r_acc
		
func rotate_right():
	if abs(spin) < max_r:
		spin += r_acc
		
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