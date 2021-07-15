extends Node2D

var gravity_vec = Vector2(0,1)
var gravity = 9.8
var mass = 0.02
var launched = false
var velocity = Vector2(0, 0)

var life_time

func _physics_process(delta):
	if launched:
		velocity += gravity_vec * gravity * mass
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(initial_velocity : Vector2, distance : float, width : int):
	Engine.time_scale = 0.5
	launched = true
	velocity = initial_velocity.rotated(rotation)
	$Trail.trail_length = distance / 100
	$Trail.width = width
	$Timer.start(life_time)

func _on_Timer_timeout():
	Globals.health_system.spawn_star_particle(global_position)
	queue_free()
