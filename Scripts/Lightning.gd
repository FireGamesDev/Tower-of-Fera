extends Node2D

const lightning_strike = preload("res://SFX/Lightning_strike.wav")
	
func get_spawn_pos():
	var positionInArea = Vector2(0,0)
	var centerpos = $SpawnArea/CollisionShape2D.position + $SpawnArea.position
	var size = $SpawnArea/CollisionShape2D.shape.extents
	
	positionInArea.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	positionInArea.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	
	return positionInArea


func _on_Timer_timeout():
	$TextureProgress.set_position(get_spawn_pos())
	$AnimationPlayer.play("Lightning")
	$TextureProgress.visible = true
	$Timer.start(randi()%30+6)
	yield(get_tree().create_timer(0.2), "timeout")
	Globals.sfx_manager.play_sound(lightning_strike)
	


func _on_AnimationPlayer_animation_finished(_anim_name):
	$TextureProgress.visible = false
