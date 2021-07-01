extends KinematicBody2D

const FLOOR = Vector2(0,-1)

export var dummies = false

var health

var speed
var velocity = Vector2(0,0)

func _process(_delta):
	if !dummies:
		velocity.x = -speed
		var _move = move_and_slide(velocity, FLOOR)
