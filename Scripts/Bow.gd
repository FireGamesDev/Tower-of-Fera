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

var shoot_force = 400

enum JoystickMode {FIXED, DYNAMIC, FOLLOWING}

func _input(event):
#	if event.is_action_pressed("shoot"):
#		aiming = true
#		on_drag_start()
#	if event.is_action_released("shoot"):
#		aiming = false
#		on_drag_end()
		
	if !Globals.can_shoot:
		return

	if event is InputEventScreenTouch:
		if event.is_pressed() and (Globals.joystick._is_inside_joystick(event) or Globals.joystick.joystick_mode == JoystickMode.DYNAMIC):
			if Globals.arrows > 0:
				if arrow == null:
					aiming = true
					on_drag_start()
		elif $Sprite.get_child_count() > 4:
			var rotation_value = rad2deg(Globals.joystick.front.global_position.angle_to_point(Globals.joystick.back.global_position)) + 180
			if rotation_value > 50 and rotation_value < 310:
				return
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
	$Sprite/BowAnim.play("Bow")
	Globals.sfx_manager.play_shoot_sound(shoot_sfx)
	
	shoot()
	
func on_drag():
	endpoint = get_local_mouse_position()
	force = -Globals.joystick.output * shoot_force
	
	if force.x > 100:
		$Sprite.frame = 1
	if force.x > 200:
		$Sprite.frame = 2
		
	var rotation_value = rad2deg(Globals.joystick.front.global_position.angle_to_point(Globals.joystick.back.global_position)) + 180
	if rotation_value > 50 and rotation_value < 310:
		Globals.joystick.can_move = false
		Globals.joystick.front.global_position = get_global_mouse_position()
		return #if the rotation looks weird
	else: Globals.joystick.can_move = true
	
	$Sprite.rotation_degrees = rotation_value
	arrow.rotation_degrees = $Sprite.rotation_degrees
	
	if Globals.trajectory:
		Globals.trajectory.update_dots($Sprite/Muzzle.position, force)
		
func shoot():
	if Globals.health_system.health == 1:
		if Globals.game_mode != "Boss":
			arrow.scale = Vector2(10,10)
	else: arrow.scale = Vector2(1,1)
	
	$Sprite.remove_child(arrow)
	self.add_child(arrow)
	arrow.set_trail_length(force.x / 10)
	arrow.launch(force)
	
	arrow = null
	
	if Globals.arrows > 0:
		$Sprite/AnimationPlayer.play("Arrow_appear")
		$SFXPlayer/Delay.start(0.5)

func _on_Timer_timeout():
	if Globals.arrows > 0 and !aiming:
		$Sprite/Arrow.visible = true
	else: $Sprite/Arrow.visible = false


func _on_Delay_timeout():
	$SFXPlayer.play()
