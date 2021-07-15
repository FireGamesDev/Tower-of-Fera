extends Node2D

const boss_bullet = preload("res://Scenes/Boss_bullet.tscn")

const shoot_sfx = preload("res://SFX/Collect.wav")

var shoot_force = 0.5

var distance
var direction
var force

var is_died = false

func _ready():
	Globals.boss = self

func shoot():
	$Idle/IdleAnim.stop(true)
	$Idle.visible = false
	$Sprite.visible = true
	$Sprite/AnimationPlayer.play("Bow")
	
	var bullet = boss_bullet.instance()
	
	distance = rand_range(1000,1200)
	direction = Vector2(-1, -1)
	force = direction * distance * shoot_force
	
	bullet.launch(force, distance)
	Globals.health_system.spawn_explosion_particle($SpawnPoint.global_position)
	Globals.sfx_manager.play_shoot_sound(shoot_sfx)
	$SpawnPoint.call_deferred("add_child", bullet)

func _on_ShootTimer_timeout():
	if is_died or Globals.is_ended:
		return
	shoot()
	var time = rand_range(2.5,2)
	$ShootTimer.start(time)


func _on_AnimationPlayer_animation_finished(_anim_name):
	$Sprite.visible = false
	$Idle.visible = true
	$Idle/IdleAnim.play("Idle")
	
func die():
	is_died = true
	$Explosion.emitting = true
	$Idle/IdleAnim.play("Fade")


func _on_IdleAnim_animation_finished(anim_name):
	if anim_name == "Fade":
		queue_free()
