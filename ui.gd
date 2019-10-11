extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update()


func update():
	$HBoxContainer/score.text = "score:" + str(game_manager.score)
	$HBoxContainer/level.text = "level:" + str(game_manager.level)
	$HBoxContainer/shields.text = "shields:" + str(game_manager.shields)
	$HBoxContainer/fire_rate.text = "fire rate:" + str(game_manager.fire_rate)
	#if score gets high enough offer an upgrade to the player
	
func level_up():
	$AnimationPlayer.play("major_update")