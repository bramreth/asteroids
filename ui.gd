extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	setup_degug()


func update():
	$HBoxContainer/score.text = "score:" + str(game_manager.score)
	$HBoxContainer/level.text = "level:" + str(game_manager.level)
	$HBoxContainer/shields.text = "shields:" + str(game_manager.shields)
	$HBoxContainer/fire_rate.text = "fire rate:" + str(game_manager.fire_rate)
	#if score gets high enough offer an upgrade to the player
	
func level_up():
	$AnimationPlayer.play("major_update")
	
	
func setup_degug():
	$Panel/HBoxContainer/VBoxContainer2/speed.max_value = 500
	$Panel/HBoxContainer/VBoxContainer2/speed.min_value = 50
	$Panel/HBoxContainer/VBoxContainer2/speed.step = 10
	$Panel/HBoxContainer/VBoxContainer2/speed.value = 200
	
	$Panel/HBoxContainer/VBoxContainer2/acc.max_value = 0.5
	$Panel/HBoxContainer/VBoxContainer2/acc.min_value = 0.1
	$Panel/HBoxContainer/VBoxContainer2/acc.step = 0.05
	$Panel/HBoxContainer/VBoxContainer2/acc.value = 0.15
	
	
	$Panel/HBoxContainer/VBoxContainer2/drag.max_value = 0.95
	$Panel/HBoxContainer/VBoxContainer2/drag.min_value = 0.85
	$Panel/HBoxContainer/VBoxContainer2/drag.step = 0.01
	$Panel/HBoxContainer/VBoxContainer2/drag.value = 0.9
	
	$Panel/HBoxContainer/VBoxContainer2/max_v.max_value = 11.0
	$Panel/HBoxContainer/VBoxContainer2/max_v.min_value = 1.0
	$Panel/HBoxContainer/VBoxContainer2/max_v.step = 1.0
	$Panel/HBoxContainer/VBoxContainer2/max_v.value = 5.0
	
	$Panel/HBoxContainer/VBoxContainer2/max_r.max_value = 0.12
	$Panel/HBoxContainer/VBoxContainer2/max_r.min_value = 0.02
	$Panel/HBoxContainer/VBoxContainer2/max_r.step = 0.01
	$Panel/HBoxContainer/VBoxContainer2/max_r.value = 0.08
	
	$Panel/HBoxContainer/VBoxContainer2/r_acc.max_value = 0.050
	$Panel/HBoxContainer/VBoxContainer2/r_acc.min_value = 0.010
	$Panel/HBoxContainer/VBoxContainer2/r_acc.step = 0.005
	$Panel/HBoxContainer/VBoxContainer2/r_acc.value = 0.035
	"""
	var acc = 0.15
	var speed = 200
	var max_v = 5.0
	var r_acc = 0.035
	var max_r = 0.08
	var drag = 0.9
	"""