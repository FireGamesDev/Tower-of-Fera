extends KinematicBody2D

const FLOOR = Vector2(0,-1)

export var dummies = false

var speed
var velocity = Vector2(0,0)

func _process(_delta):
	if !dummies:
		velocity.x = -speed
		var _move = move_and_slide(velocity, FLOOR)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Tower"):
		Globals.health_system.take_damage()
		Globals.health_system.spawn_explosion_particle(area.position)
		queue_free()
