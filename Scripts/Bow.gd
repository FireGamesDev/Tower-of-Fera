extends Node2D

var aiming = false

var startpoint
var endpoint
var direction
var force
var distance

var shoot_force = 0.5

func _input(event):
	if event.is_action_pressed("shoot"):
		aiming = true
		on_drag_start()
	if event.is_action_released("shoot"):
		aiming = false
		on_drag_end()
		
	if aiming:
		on_drag()
			
func on_drag_start():
	startpoint = get_global_mouse_position()
	if Globals.trajectory:
		Globals.trajectory.show()
	
func on_drag_end():
	if Globals.trajectory:
		Globals.trajectory.hide()
	
func on_drag():
	endpoint = get_global_mouse_position()
	distance = startpoint.distance_to(endpoint)
	direction = (startpoint - endpoint).normalized()
	force = direction * distance * shoot_force
	
	if Globals.trajectory:
		Globals.trajectory.update_dots($Muzzle.position, force)
