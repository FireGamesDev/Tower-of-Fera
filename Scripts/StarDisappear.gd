extends AnimationPlayer

const star_die = preload("res://SFX/Star.wav")

func _on_StarDisappear_animation_finished(anim_name):
	if anim_name == "StarAppear":
		Globals.sfx_manager.play_sound(star_die)
		play("StarDisappear")
	else:
		Engine.time_scale = 1
		queue_free()
