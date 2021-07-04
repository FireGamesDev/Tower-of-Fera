extends Node2D

signal strike

export var stop = false

export var is_menu = false

export var is_restart_button = false

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
	if stop:
		return
	emit_signal("strike")
	var pos = get_spawn_pos()
	$TextureProgress.set_position(pos)
	if !is_menu:
		Globals.player_cam.shake(0.5,30,8)
		var hearth = heal.instance()
		hearth.position = Vector2(pos.x, pos.y + 200) # 200 is the y size of the Lightning
		call_deferred("add_child", hearth)
	$AnimationPlayer.play("Lightning")
	$TextureProgress.visible = true
	if !is_menu:
		$Timer.start(randi()%Globals.health_spawn_max+6) #diffuculty
	else: $Timer.start(randi()%50+30) 
	if !is_restart_button:
		yield(get_tree().create_timer(0.2), "timeout")
		$SFX.play()
	else: $SFX_lightning.start(0.2)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Lightning":
		$TextureProgress.visible = false


func _on_SFX_lightning_timeout():
	$SFX.play()
