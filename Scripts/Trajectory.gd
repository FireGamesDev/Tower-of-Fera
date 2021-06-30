extends Node2D

var dot_number = 20
var spacing = 0.1
const dotScene = preload("res://Scenes/TrajectoryDot.tscn")

var dots_list = []
var pos : Vector2
var time_stamp

var dot_size = 1

var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")

var min_scale = 0.03
var max_scale = 1

func _ready():
	Globals.trajectory = self
	hide()
	prepare_dots()
	
func show():
	$Dots.visible = true
	
func hide():
	$Dots.visible = false
	
func prepare_dots():
	dots_list = [dot_number]
	if Globals.trajectory_dot:
		Globals.trajectory_dot.scale = Vector2.ONE * max_scale
		
	var size : float = max_scale
	var scale_factor : float = size / dot_number
	
	for i in dot_number:
		var dot = dotScene.instance()
		dot.scale = Vector2.ONE * size
		if size > min_scale:
			size -= scale_factor
		$Dots.call_deferred("add_child", dot)
		dots_list.append(dot)

func update_dots(muzzle_pos, force_applied):
	time_stamp = spacing
	for dot in dot_number:
		pos.x = (muzzle_pos.x + force_applied.x * time_stamp)
		pos.y = (muzzle_pos.y + force_applied.y * time_stamp) + (0.5 * gravity_magnitude * time_stamp * time_stamp)
		dots_list[dot + 1].set_position(pos)
		time_stamp += spacing
