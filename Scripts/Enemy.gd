extends KinematicBody2D

const FLOOR = Vector2(0,-1)

export var dummies = false

var health

var speed
var velocity = Vector2(0,0)

func _physics_process(_delta):
	if Globals.is_ended:
		return
	if !dummies:
		velocity.x = -speed
		var _move = move_and_slide(velocity, FLOOR)
