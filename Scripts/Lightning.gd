extends Node2D

signal strike

var stop = false

export var is_menu = false

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
		$Timer.start(randi()%20+6)
	else: $Timer.start(randi()%50+30) #diffuculty
	yield(get_tree().create_timer(0.2), "timeout")
	$SFX.play()

func _on_AnimationPlayer_animation_finished(_anim_name):
	$TextureProgress.visible = false
