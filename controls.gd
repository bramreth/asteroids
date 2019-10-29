extends Node2D

var shot = preload("res://shot.tscn")
var spin = 0
var v = 0.0
var acc = 0.15
var velocity = Vector2(0, 0)
var speed = 200
var max_v = 5.0
var r_acc = 0.01
var max_r = 0.2
var drag = 0.9

var cooldown = 0

func _ready():
	game_manager.connect("val_changed", self, "update_data")
	game_manager.connect("damage", self, "screen_shake")
	game_manager.connect("level_up", self, "level_up")
	
func update_data():
	$player/Camera2D/CanvasLayer/Control.update()
	var shield_color
	if game_manager.shields < 5:
		shield_color = 1.0 - (game_manager.shields /5.0)
	else:
		shield_color = 0
	$player/Sprite.modulate = Color(shield_color,1.0,1.0,1.0)
	check_score()
	
func check_score():
	if game_manager.score > game_manager.level * game_manager.level:
		game_manager.level_up()
		level_up()
		
func level_up():
	$player/Camera2D/CanvasLayer/Control.level_up()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# handle rotation
	if Input.is_action_pressed("joy_down") or Input.is_action_pressed("joy_up") or Input.is_action_pressed("joy_left") or Input.is_action_pressed("joy_right"):
		if not Input.is_action_pressed("brake"):
			thrust()
	spin *= drag
		
	$player.rotate(spin)
	
	
		
	# handle thrust
	if Input.is_action_pressed("ui_up"):
		thrust()
	else:
		v *= drag
	velocity = Vector2(v, 0).rotated($player.rotation) * speed
	interp_path()
	velocity = $player.move_and_slide(velocity)
	
	# handle shooting
	if game_manager.fire_rate:
		if Input.is_action_pressed("shoot"):
			fire_automatic()
	elif Input.is_action_just_pressed("shoot"):
		fire_weapon()

func interp_path():
	var path = Vector2()
	#https://www.gamedev.net/forums/topic/445890-clockwise-or-counterclockwise/
	path.x = Input.get_action_strength("joy_right") - Input.get_action_strength("joy_left")
	path.y = Input.get_action_strength("joy_down") - Input.get_action_strength("joy_up")
	#path = path.normalized()
	if path:
#		$player.rotation = path.angle()
#		if $player.rotation - path.angle() > 0:
#			rotate_left()
#		else:
#			rotate_right()
			
		var direction = cos($player.rotation)*sin(path.angle()) - cos(path.angle())*sin($player.rotation);
		print(direction)
		if(direction > 0.0):
			rotate_right(direction)
		else:
			rotate_left(direction)
#		if $player.get_angle_to(path) > 0:
#			rotate_left()
#		if $player.get_angle_to(path) < 0:
#			rotate_right()
#		print($player.get_angle_to(path))
#		print($player.rotation)
#	if velocity != path:
#		rotate_left()
#		print(path, velocity)
	
#	print(path, velocity)
#	print(velocity)
#	velocity = $player.move_and_slide(path * 500)
	


func thrust():
	if v < max_v:
		v += acc

func rotate_left(mag):
	if abs(spin) < max_r:
		spin -= r_acc*abs(mag)
		
func rotate_right(mag):
	if abs(spin) < max_r:
		spin += r_acc*abs(mag)
		
func fire_weapon():
	var instance = shot.instance()
	get_parent().add_child(instance)
	instance.spawn(Vector2(1.0, 0).rotated($player.rotation) * 15.0)
	instance.transform = $player/weapon.get_global_transform()

func fire_automatic():
	if cooldown: return
	else:
		var instance = shot.instance()
		get_parent().add_child(instance)
		instance.spawn(Vector2(1.0, 0).rotated($player.rotation) * 15.0)
		instance.transform = $player/weapon.get_global_transform()
		cooldown = true
		yield(get_tree().create_timer(0.35 - game_manager.fire_rate*0.05), "timeout")
		cooldown = false

func set_limit(left, top, bottom, right):
	$player/Camera2D.limit_left = left
	$player/Camera2D.limit_right = right
	$player/Camera2D.limit_top = top
	$player/Camera2D.limit_bottom = bottom
	
func screen_shake():
	$player/Camera2D/screen_shake_player.play("shake")