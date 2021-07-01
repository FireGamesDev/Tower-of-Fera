extends Node2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("Arrow"):
		Globals.health_system.heal()
		Globals.health_system.spawn_explosion_particle(area.global_position)
		queue_free()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
