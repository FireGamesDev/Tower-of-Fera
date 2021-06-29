extends Control

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		queue_free()


func _on_Logo_tree_entered():
	if Globals.once:
		$AnimationPlayer.play("Logo")
		Globals.once = false
	else: 
		queue_free()


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
