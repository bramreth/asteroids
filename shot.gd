extends Node2D

var velocity = Vector2(0,0)
var lifespan = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn(dir):
	velocity = dir
	yield(get_tree().create_timer(lifespan), "timeout")
	self.queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity)

#hit on an area
func _on_shot_area_entered(area):
	print(area.name)

# hit on a physics body
func _on_shot_body_entered(body):
	print(body.name)
	if body.name == "asteroid":
		body.get_parent().damage()
		destroyed()
		
func destroyed():
	queue_free()

