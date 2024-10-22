extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func change_scene_to_file(path, delay = 0.5):
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards("fade")
