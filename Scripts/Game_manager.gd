extends Node2D

const click_sound = preload("res://SFX/Collect.wav")
const win_sfx = preload("res://SFX/Win.wav")
const lose_sfx = preload("res://SFX/Lose.wav")

var remaining_text
var wave_text

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_manager = self
	Globals.player_cam = $CanvasLayer/Camera2D
	wave_text = $CanvasLayer/Waves
	remaining_text = $CanvasLayer/Remaining
	$CanvasLayer/Menu.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Win/Win.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Menu.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Lose/Restart.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Lose/Menu_lose.set_focus_mode(Control.FOCUS_NONE)
	set_rain()
	
func die():
	Globals.sfx_manager.play_sound(lose_sfx)
	if Globals.waves_count -1 == 0:
		$CanvasLayer/Win/Text.bbcode_text = "\n[wave]THE TOWN FALLED!"
	else: $CanvasLayer/Win/Text.bbcode_text = "\n[wave]THE TOWN FALLED! \nCLEARED WAVES: " + str(Globals.waves_count -1)
	if Globals.score < Globals.waves_count -1:
		Globals.save_score(Globals.waves_count -1)
	$CanvasLayer/Lose.visible = true
	
func win():
	#Globals.save_progress()
	if Globals.score < Globals.waves_count:
		Globals.save_score(Globals.waves_count)
	Globals.sfx_manager.play_sound(win_sfx)
	$CanvasLayer/Win.visible = true
	var cleared_mode = Globals.game_mode
	$CanvasLayer/Win/Text.bbcode_text = "\n[wave]YOU CLEARED " + str(cleared_mode.to_upper())


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


func _on_Win_light_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Win/Win/AnimationPlayer.play("PlayButton")


func _on_Win_pressed():
	$CanvasLayer/Win/Win/Win_light._on_Timer_timeout()
	$CanvasLayer/Win/Win/Win_light.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)


func _on_Menu_lose_pressed():
	$CanvasLayer/Lose/Menu_lose/Menu_lose._on_Timer_timeout()
	$CanvasLayer/Lose/Menu_lose/Menu_lose.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)


func _on_Menu_lose_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Lose/Menu_lose/AnimationPlayer.play("PlayButton")


func _on_Restart_pressed():
	$CanvasLayer/Lose/Restart/Restart_strike._on_Timer_timeout()
	$CanvasLayer/Lose/Restart/Restart_strike.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	$CanvasLayer/Lose.visible = false
	get_tree().call_deferred("reload_current_scene")


func _on_Restart_strike_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Lose/Restart/AnimationPlayer.play("PlayButton")
