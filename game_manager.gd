extends Node

signal val_changed()
signal level_up()
signal damage()
var score = 0
var level = 1
var shields = 0
var fire_rate = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_score(value):
	score += value
	emit_signal("val_changed")
	
func level_up():
	level += 1
	shields += 1
	if level % 2 == 0 and fire_rate < 6:
		fire_rate += 1
	score = 0
	emit_signal("val_changed")
	emit_signal("level_up")
	
func damage_player():
	if shields < 1:
		pass
#		get_tree().quit()
	else:
		shields -= 1
		emit_signal("damage")
		emit_signal("val_changed")
