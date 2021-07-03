extends Node2D

const shoot_sfx = preload("res://SFX/Collect.wav")

const arrowAsset = preload("res://Scenes/Arrow.tscn")
var arrow

var aiming = false

var startpoint
var endpoint
var direction
var force
var distance

var shoot_force = 0.5

func _input(event):
#	if event.is_action_pressed("shoot"):
#		aiming = true
#		on_drag_start()
#	if event.is_action_released("shoot"):
#		aiming = false
#		on_drag_end()

	if Globals.game_mode != "Train":
		Globals.can_shoot = true
		
	if !Globals.can_shoot:
		return

	if event is InputEventScreenTouch:
		if event.is_pressed():
			if Globals.arrows > 0:
				aiming = true
				on_drag_start()
		elif $Sprite.get_child_count() > 2:
			aiming = false
			on_drag_end()
		
	if aiming:
		on_drag()
		
func on_drag_start():
	startpoint = get_local_mouse_position()
	arrow = arrowAsset.instance()
	arrow.set_position($Sprite/Muzzle.position)
	$Sprite.call_deferred("add_child", arrow)

	Globals.arrows -= 1
	Globals.arrow_ammo_system.manage_arrows()
	
	if Globals.trajectory:
		Globals.trajectory.show()
	
func on_drag_end():
	if Globals.trajectory:
		Globals.trajectory.hide()
	$Sprite/AnimationPlayer.play("Bow")
	Globals.sfx_manager.play_shoot_sound(shoot_sfx)
	
	$Line2D.remove_point(1)
	$Line2D.remove_point(0) 
	
	shoot()
	
func on_drag():
	endpoint = get_local_mouse_position()
	distance = startpoint.distance_to(endpoint)
	direction = (startpoint - endpoint).normalized()
	force = direction * distance * shoot_force

	
	if !$Line2D.points.empty():
		$Line2D.remove_point(1)
		$Line2D.remove_point(0) 
	
	$Line2D.add_point(startpoint)
	$Line2D.add_point(endpoint)
	
	if force.x > 100:
		$Sprite.frame = 1
	if force.x > 200:
		$Sprite.frame = 2
	$Sprite.look_at(startpoint - endpoint)
	arrow.rotation = $Sprite.rotation
	
	if Globals.trajectory:
		Globals.trajectory.update_dots($Sprite/Muzzle.position, force)
		
func shoot():
	$Sprite.remove_child(arrow)
	self.add_child(arrow)
	arrow.launch(force)
