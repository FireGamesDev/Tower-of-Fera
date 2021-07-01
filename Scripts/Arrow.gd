extends Area2D

const kill_sfx1 = preload("res://SFX/Die1.wav")
const kill_sfx2 = preload("res://SFX/Die2.wav")

var mass = 0.10
var launched = false
var velocity = Vector2(0, 0)

var fade_time = 5
var fade = 1

var current_body

func _process(delta):
	if launched:
		velocity += gravity_vec * gravity * mass
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(initial_velocity : Vector2):
	launched = true
	velocity = initial_velocity

func _on_Arrow_area_shape_entered(_area_id, area, _area_shape, _local_shape):
	if area.is_in_group("Ground"):
		launched = false
		$Anim.play("Arrow_fade")


func _on_Anim_animation_finished(_anim_name):
	queue_free()


func _on_Arrow_body_entered(body):
	if body.is_in_group("Enemy"):
		Globals.health_system.spawn_explosion_particle(body.global_position)
		if randi()%2+1 == 1:
			Globals.sfx_manager.play_kill_sound(kill_sfx1)
		else: Globals.sfx_manager.play_kill_sound(kill_sfx2)
		body.queue_free()
	if body.is_in_group("Tank"):
		if current_body != null:
			if current_body == body:
				return
		current_body = body
		launched = false
		$Anim.set_speed_scale(0.5)
		$Anim.play("Arrow_fade")
		call_deferred("reparent", self, body)
		Globals.health_system.spawn_explosion_particle(body.global_position)
		if randi()%2+1 == 1:
			Globals.sfx_manager.play_kill_sound(kill_sfx1)
		else: Globals.sfx_manager.play_kill_sound(kill_sfx2)
		body.health -= 1
		if body.health == 0:
			body.queue_free()


func reparent(node, body):
	node.get_parent().remove_child(node)
	body.add_child(node)
