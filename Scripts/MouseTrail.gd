extends Line2D

var point
export var trail_length = 10
	
func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	point = get_global_mouse_position()
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)
