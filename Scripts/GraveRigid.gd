extends Node2D

var mass = 0.10
var launched = false
var velocity = Vector2(0, 0)

var fade_time = 5
var fade = 1

var current_body
var gravity = 9.8
var gravity_vec = Vector2(0, 1)

func _process(delta):
	if launched:
		velocity += gravity_vec * gravity * mass
		position += velocity * delta
		
func launch():
	launched = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("Ground"):
		yield(get_tree().create_timer(0.1), "timeout")
		launched = false
		$AnimationPlayer.play("grave_appear")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "grave_appear":
		$AnimationPlayer.play("Grave_fade")
	else: queue_free()
