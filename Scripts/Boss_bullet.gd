extends Area2D

const kill_sfx1 = preload("res://SFX/Die1.wav")
const kill_sfx2 = preload("res://SFX/Die2.wav")

var mass = 0.30
var launched = false
var velocity = Vector2(0, 0)

var current_body

func _process(delta):
	if launched:
		velocity += gravity_vec * gravity * mass
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(initial_velocity : Vector2):
	launched = true
	velocity = initial_velocity.rotated(rotation)

func reparent(node, body):
	node.get_parent().remove_child(node)
	body.add_child(node)

func _on_Boss_bullet_area_entered(area):
	if area.is_in_group("Arrow"):
		if current_body != null:
			if current_body == area:
				return
		current_body = area
		
		Globals.arrows += 1
		Globals.arrow_ammo_system.manage_arrows()
		
		area.mass += mass
		
		launched = false
		call_deferred("reparent", self, area)
		position = Vector2(0,0)
		scale = Vector2(0.4,0.4)
		
	if area.is_in_group("Boss") and !launched:
		Globals.health_system.spawn_explosion_particle(global_position)
		if randi()%2+1 == 1:
			Globals.sfx_manager.play_kill_sound(kill_sfx1)
		else: Globals.sfx_manager.play_kill_sound(kill_sfx2)
		take_damage()
		queue_free()
		
	if area.is_in_group("Tower"):
		Globals.arrows += 1
		Globals.arrow_ammo_system.manage_arrows()
		
		Globals.player_cam.shake(0.5,15,8)
		Globals.health_system.take_damage()
		Globals.health_system.spawn_explosion_particle(global_position)
		queue_free()
		
func take_damage():
	Globals.game_manager.take_damage()
