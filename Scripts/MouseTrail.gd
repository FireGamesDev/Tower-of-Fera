extends Line2D

var point
export var trail_length = 10

var can_move = false

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	can_move = true
	
func _process(_delta):
	if can_move:
		global_position = Vector2(0,0)
		global_rotation = 0
		point = get_global_mouse_position()
		add_point(point)
		while get_point_count() > trail_length:
			remove_point(0)
