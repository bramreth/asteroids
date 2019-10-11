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
	if game_manager.fire_rate:
		if Input.is_action_pressed("ui_accept"):
			fire_automatic()
	elif Input.is_action_just_pressed("ui_accept"):
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