extends Area2D

var mass = 0.10
var launched = false
var velocity = Vector2(0, 0)

var fade_time = 5
var fade = 1

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
		Globals.health_system.spawn_explosion_particle(body.position)
		body.queue_free()
		queue_free()
