extends Control

signal logo_finished

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		emit_signal("logo_finished")
		queue_free()


func _on_Logo_tree_entered():
	if Globals.once:
		$AnimationPlayer.play("Logo")
		Globals.once = false
	else: 
		queue_free()


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("logo_finished")
	queue_free()
