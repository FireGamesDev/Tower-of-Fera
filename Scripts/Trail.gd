extends Line2D

var point
@export var trail_length = 10
	
func _process(_delta: float) -> void:
	if !get_parent():
		queue_free()
		return

	global_transform.origin = Vector2(0, 0)

	var point = get_parent().global_transform.origin
	add_point(point)

	#while get_point_count() > trail_length:
		#remove_point(0)
