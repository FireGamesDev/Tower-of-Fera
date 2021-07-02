extends Node2D

const click_sound = preload("res://SFX/Collect.wav")

var remaining_text
var wave_text

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_manager = self
	Globals.player_cam = $CanvasLayer/Camera2D
	wave_text = $CanvasLayer/Waves
	remaining_text = $CanvasLayer/Remaining
	$CanvasLayer/Menu.set_focus_mode(Control.FOCUS_NONE)
	set_rain()
	
func die():
	pass
	
func win():
	pass


func _on_Tower_body_entered(body):
	if body.is_in_group("Enemy"):
		Globals.player_cam.shake(0.5,15,8)
		Globals.health_system.take_damage()
		Globals.health_system.spawn_explosion_particle(body.global_position)
		body.queue_free()
		
func set_rain():
	if Globals.game_mode == "Hard":
		$Rain.amount = 200
	if Globals.game_mode == "Normal":
		$Rain.amount = 100
	if Globals.game_mode == "Easy":
		$Rain.amount = 50
	if Globals.game_mode == "Endless":
		$Rain.amount = 100


func _on_Hard_light_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Menu/AnimationPlayer.play("PlayButton")


func _on_Menu_pressed():
	$CanvasLayer/Menu/Hard_light._on_Timer_timeout()
	$CanvasLayer/Menu/Hard_light.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)
