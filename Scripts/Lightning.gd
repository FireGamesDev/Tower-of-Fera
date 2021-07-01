extends Node2D

const lightning_strike = preload("res://SFX/Lightning_strike.wav")
const heal = preload("res://Scenes/Heal.tscn")
	
func get_spawn_pos():
	var positionInArea = Vector2(0,0)
	var centerpos = $SpawnArea/CollisionShape2D.position + $SpawnArea.position
	var size = $SpawnArea/CollisionShape2D.shape.extents
	
	positionInArea.x = (randi() % int(size.x)) - (size.x/2) + centerpos.x
	positionInArea.y = (randi() % int(size.y)) - (size.y/2) + centerpos.y
	
	return positionInArea


func _on_Timer_timeout():
	var pos = get_spawn_pos()
	$TextureProgress.set_position(pos)
	var hearth = heal.instance()
	hearth.position = Vector2(pos.x, pos.y + 200) # 200 is the y size of the Lightning
	call_deferred("add_child", hearth)
	$AnimationPlayer.play("Lightning")
	$TextureProgress.visible = true
	$Timer.start(randi()%20+6)
	yield(get_tree().create_timer(0.2), "timeout")
	$SFX.play()

func _on_AnimationPlayer_animation_finished(_anim_name):
	$TextureProgress.visible = false
