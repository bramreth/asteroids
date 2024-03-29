extends Line2D

var target
var point
export(NodePath) var origin
export var trail_length = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(origin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation = 0
	global_position = Vector2(0,0)
	point = target.global_position
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)
