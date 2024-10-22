extends CharacterBody2D

const FLOOR = Vector2(0,-1)

@export var dummies = false

var health

var speed
var _velocity = Vector2(0,0)

func _physics_process(_delta):
	if Globals.is_ended:
		return
	if !dummies:
		_velocity.x = -speed
		set_velocity(_velocity)
		set_up_direction(FLOOR)
		move_and_slide()
		var _move = _velocity
