extends Line2D

var point
export var trail_length = 10

func _enter_tree():
	set_as_toplevel(true)

func _physics_process(_delta):
	point = get_parent().global_position
	add_point(point)

	if points.size() > trail_length:
		remove_point(0)

