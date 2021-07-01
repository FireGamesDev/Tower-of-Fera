extends Control

var health

const explosion = preload("res://Scenes//Explosion.tscn")
const heal_sfx = preload("res://SFX/Heal.wav")
const heartbeat_sfx = preload("res://SFX/Heartbeat.wav")
const bad_sfx = preload("res://SFX/Collect.wav")

export var empty_hearth : Texture
export var full_hearth : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.health_system = self
	Globals.heartbeat = $Heartbeat
	reset_health()
	
func reset_health():
	health = 4
	manage_sprites(false)
	
func take_damage():
	health -= 1
	manage_sprites(false)
	if health == 1:
		$Sprite1.visible = false
		$Sprite2.visible = false
		$Sprite3.visible = false
		$Heartbeat.play("Heartbeat")
		Globals.heartbeat_player.set_speed_scale(8)
		Globals.sfx_manager.play_sound(heartbeat_sfx)
	else:
		$Sprite1.visible = true
		$Sprite2.visible = true
		$Sprite3.visible = true
		$Heartbeat.stop()
	if health == 0:
		die()
	$Timer.start()
	
func heal():
	_on_Timer_timeout()
	Globals.sfx_manager.play_sound(heal_sfx)
	$Sprite1.visible = true
	$Sprite2.visible = true
	$Sprite3.visible = true
	$Heartbeat.stop()
	$Sprite.scale= Vector2(5,5)
	if health < 4:
		health += 1
		manage_sprites(true)
		$HealthPlus.visible = true
		$Timer.start()
	else: Globals.sfx_manager.play_sound(bad_sfx)

func die():
	Globals.game_manager.die()
	$Heartbeat.stop()
	$Sprite.scale= Vector2(5,5)
	
func manage_sprites(is_heal):
	if health == 4:
		$Sprite.texture = full_hearth
		$Sprite1.texture = full_hearth
		$Sprite2.texture = full_hearth
		$Sprite3.texture = full_hearth
		pass
	if health == 3:
		$Sprite.texture = full_hearth
		$Sprite1.texture = full_hearth
		$Sprite2.texture = full_hearth
		$Sprite3.texture = empty_hearth
		if !is_heal:
			$Sprite3/Slash.visible = true
		pass
	if health == 2:
		$Sprite.texture = full_hearth
		$Sprite1.texture = full_hearth
		$Sprite2.texture = empty_hearth
		$Sprite3.texture = empty_hearth
		if !is_heal:
			$Sprite2/Slash.visible = true
		pass
	if health == 1:
		$Sprite.texture = full_hearth
		$Sprite1.texture = empty_hearth
		$Sprite2.texture = empty_hearth
		$Sprite3.texture = empty_hearth
		if !is_heal:
			$Sprite1/Slash.visible = true
		pass
	if health == 0:
		$Sprite.texture = empty_hearth
		$Sprite1.texture = empty_hearth
		$Sprite2.texture = empty_hearth
		$Sprite3.texture = empty_hearth
		if !is_heal:
			$Sprite/Slash.visible = true
		pass

func _on_Timer_timeout():
	$Sprite/Slash.visible = false
	$Sprite1/Slash.visible = false
	$Sprite2/Slash.visible = false
	$Sprite3/Slash.visible = false
	$HealthPlus.visible = false
	
func spawn_explosion_particle(pos):
	var particle = explosion.instance()
	particle.set_emitting(true)
	get_parent().get_parent().add_child(particle)
	particle.position = pos
