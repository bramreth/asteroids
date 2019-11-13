extends Node2D

var shot = preload("res://shot.tscn")
var dialog = preload("res://dialog.tscn")
var spin = 0
var v = 0.0
var acc = 0.15
var velocity = Vector2(0, 0)
var speed = 200
var max_v = 5.0
var r_acc = 0.035
var max_r = 0.08
var drag = 0.9

var cooldown = 0

export var DEBUG = true

var in_menu = false

func _ready():
	game_manager.connect("val_changed", self, "update_data")
	game_manager.connect("damage", self, "screen_shake")
	game_manager.connect("level_up", self, "level_up")
	
	dialog()
	
func dialog():
	if not in_menu:
		in_menu = true
		var instance = dialog.instance()
		$player/Camera2D/CanvasLayer.add_child(instance)
		instance.connect("exit_dialog", self, "exit_dialog")
	
func exit_dialog():
	in_menu = false
	
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
		
	if Input.is_action_just_pressed("view_ship"):
		dialog()
		
	if Input.is_action_just_pressed("start"):
		get_tree().quit()
		
	"""
	this value needs smoothing over an ammount of time say the avg speed over a half second buffer.
	then to be interpolated to stages according to that average speed.
	"""
#	if v < 2.0:
#		$player/Camera2D.zoom.x = 0.65 - (v/40.0)
#		$player/Camera2D.zoom.y = 0.65 - (v/40.0)
#	else:
#		$player/Camera2D.zoom.x = 0.65 - 0.1
#		$player/Camera2D.zoom.y = 0.65 - 0.1
		
	
#	print(spin)

func interp_path():
	var path = Vector2()
	#https://www.gamedev.net/forums/topic/445890-clockwise-or-counterclockwise/
	path.x = Input.get_action_strength("joy_right") - Input.get_action_strength("joy_left")
	path.y = Input.get_action_strength("joy_down") - Input.get_action_strength("joy_up")
	#path = path.normalized()
	if DEBUG:
		$player/path.points[1] = path * 100
		$player/path.global_rotation = 0
	if path:
#		$player.rotation = path.angle()
#		if $player.rotation - path.angle() > 0:
#			rotate_left()
#		else:
#			rotate_right()
			
		var direction = cos($player.rotation)*sin(path.angle()) - cos(path.angle())*sin($player.rotation)
		var a1 = rad2deg($player.rotation)
		var a2 = rad2deg(path.angle())
		var dist = abs(a1 - a2)
		dist = min(360-dist, dist)
		dist /= 180
		print(dist)
		if dist < 0.1:
			dist = 0.1
		
		if(direction > 0.0):
			rotate_right(dist)#a2)
		else:
			rotate_left(dist)#a2)
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
	var path = Vector2()
	#var size = max(Input.get_action_strength("joy_right"), max(Input.get_action_strength("joy_left"), max(Input.get_action_strength("joy_down"), Input.get_action_strength("joy_up"))))
	path.x = Input.get_action_strength("joy_right") - Input.get_action_strength("joy_left")
	path.y = Input.get_action_strength("joy_down") - Input.get_action_strength("joy_up")
	
	path = path.clamped(1)
#	var joystickstrength = sqrt(pow(abs(path.y),2) + pow(abs(path.x),2))
#	print(joystickstrength, "marker")
	var mg = abs(path.x) + abs(path.y)
	print(abs(path.x) + abs(path.y))
	if v < max_v:
		v += acc * mg
	

func rotate_left(mag):
	if abs(spin) < max_r:
		if mag < 0.15:
			spin -= r_acc*abs(mag)
		else:
			spin -= r_acc
		if DEBUG:
			$player/path2.points[1] = Vector2(0, spin*1000) 
			
func rotate_right(mag):
	if abs(spin) < max_r:
		if mag < 0.15:
			spin += r_acc*abs(mag)
		else:
			spin += r_acc
		if DEBUG:
			$player/path2.points[1] = Vector2(0, spin*1000) 
		
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