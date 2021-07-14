extends Node2D

const click_sound = preload("res://SFX/Collect.wav")
const win_sfx = preload("res://SFX/Win.wav")
const lose_sfx = preload("res://SFX/Lose.wav")

var remaining_text
var wave_text

enum JoystickMode {FIXED, DYNAMIC, FOLLOWING}

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.is_ended = false
	Globals.game_manager = self
	Globals.player_cam = $CanvasLayer/Camera2D
	Globals.train_timer = $CanvasLayer/TimerText
	Globals.menu_button_in_game = $CanvasLayer/Menu
	
	wave_text = $CanvasLayer/Waves
	remaining_text = $CanvasLayer/Remaining
	$CanvasLayer/Menu.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Win/Win.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Menu.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Lose/Restart.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Lose/Menu_lose.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Tutorial/Close_tutorial.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Tutorial/DynamicJoystick.set_focus_mode(Control.FOCUS_NONE)
	set_rain()
	
	#load
	if Globals.dynamic_joystick == null:
		Globals.dynamic_joystick = false
	$CanvasLayer/Tutorial/DynamicJoystick.pressed = Globals.dynamic_joystick
	if Globals.dynamic_joystick:
		Globals.joystick.joystick_mode = JoystickMode.DYNAMIC
	else: Globals.joystick.joystick_mode = JoystickMode.FIXED
	
	if Globals.game_mode == "Train":
		$CanvasLayer/Tutorial/Close_tutorial/AnimationPlayer.play("Appear")
		Globals.can_shoot = false
		
	if Globals.game_mode == "Boss":
		$CanvasLayer/BossBar.visible = true
		$CanvasLayer/Waves.visible = false
	
func die():
	for bullet in get_tree().get_nodes_in_group("boss_bullet"):
		bullet.queue_free()
	$Map/Lightning.stop = true
	Globals.is_ended = true
	Globals.sfx_manager.play_sound(lose_sfx)
	$CanvasLayer/Lose.visible = true
	if Globals.game_mode == "Endless":
		if Globals.endless_wave_save < Globals.wave -1:
			Globals.save_endless_score(Globals.wave -1)
		$CanvasLayer/Lose/Text.bbcode_text = "\n[wave]CLEARED WAVES: " + str(Globals.wave -1)
		return
	if Globals.wave -1 == 0:
		$CanvasLayer/Lose/Text.bbcode_text = "\n[wave]THE TOWN FALLED!"
	else: $CanvasLayer/Lose/Text.bbcode_text = "\n[wave]THE TOWN FALLED! \nCLEARED WAVES: " + str(Globals.wave -1)
	if Globals.wave_save < Globals.wave -1:
		Globals.save_score(Globals.wave -1)
	
func win(is_train):
	$Map/Lightning.stop = true
	Globals.is_ended = true
	if is_train:
		$CanvasLayer/TrainScoreText.bbcode_text = ""
		$CanvasLayer/TimerText.bbcode_text = ""
		Globals.sfx_manager.play_sound(win_sfx)
		$CanvasLayer/Win.visible = true
		$CanvasLayer/Win/Text.bbcode_text = "\n[wave]YOU KILLED " + str(Globals.train_point) + " [/wave] [shake]GIMPS!"
		return
	Globals.save_progress()
	if Globals.wave_save < Globals.waves_count:
		Globals.save_score(Globals.waves_count)
	Globals.sfx_manager.play_sound(win_sfx)
	$CanvasLayer/Win.visible = true
	var cleared_mode = Globals.game_mode
	$CanvasLayer/Win/Text.bbcode_text = "\n[wave]YOU CLEARED " + str(cleared_mode.to_upper()) + "\n\nCONGRATS!"
	if cleared_mode == "Boss":
		$CanvasLayer/Win/Text.bbcode_text = "\n[wave]YOU DEFEATED THE KING!\n\nCONGRATS!"


func _on_Tower_body_entered(body):
	if body.is_in_group("Enemy") or body.is_in_group("Tank"):
		Globals.arrows += 1
		Globals.arrow_ammo_system.manage_arrows()
		
		Globals.player_cam.shake(0.5,15,8)
		Globals.health_system.take_damage()
		Globals.health_system.spawn_explosion_particle(body.global_position)
		Globals.remaining_enemies -= 1
		Globals.spawner.set_remaining_text()
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
	Engine.time_scale = 1
	$CanvasLayer/Menu/Hard_light._on_Timer_timeout()
	$CanvasLayer/Menu/Hard_light.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)


func _on_Win_light_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Win/Win/AnimationPlayer.play("PlayButton")


func _on_Win_pressed():
	Engine.time_scale = 1
	$CanvasLayer/Win/Win/Win_light._on_Timer_timeout()
	$CanvasLayer/Win/Win/Win_light.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)


func _on_Menu_lose_pressed():
	Engine.time_scale = 1
	$CanvasLayer/Lose/Menu_lose/Menu_lose._on_Timer_timeout()
	$CanvasLayer/Lose/Menu_lose/Menu_lose.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Menu.tscn", 0.5)


func _on_Menu_lose_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Lose/Menu_lose/AnimationPlayer.play("PlayButton")


func _on_Restart_pressed():
	Engine.time_scale = 1
	$CanvasLayer/Lose/Restart/Restart_strike._on_Timer_timeout()
	$CanvasLayer/Lose/Restart/Restart_strike.stop = true
	$Map/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	$CanvasLayer/Lose.visible = false
	get_tree().call_deferred("reload_current_scene")


func _on_Restart_strike_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Lose/Restart/AnimationPlayer.play("PlayButton")


func _on_Tutorial_light_strike():
	Globals.player_cam.shake(0.5,15,8)
	$CanvasLayer/Tutorial/Close_tutorial/AnimationPlayer.play("PlayButton")


func _on_Close_tutorial_pressed():
	Globals.can_shoot = true
	$CanvasLayer/Tutorial/Close_tutorial/Tutorial_light._on_Timer_timeout()
	$CanvasLayer/Tutorial/Close_tutorial/Tutorial_light.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	$CanvasLayer/Tutorial/Close_tutorial/AnimationPlayer.play_backwards("Appear")
	yield(get_tree().create_timer($CanvasLayer/Tutorial/Close_tutorial/AnimationPlayer.current_animation_length), "timeout")
	$CanvasLayer/Tutorial.visible = false
	
	#start train
	Globals.train_point = 0
	if Globals.spawner:
		Globals.spawner.train()
	
func set_train_score_text():
	$CanvasLayer/TrainScoreText.bbcode_text = "\n[wave]SCORE: " + str(Globals.train_point)
	
func take_damage():
	$CanvasLayer/BossBar.value -= 5
	$CanvasLayer/BossBar/BossText.bbcode_text = "\n[wave]HEALTH: " + str($CanvasLayer/BossBar.value)
	
	if $CanvasLayer/BossBar.value <= 0:
		Globals.boss.die()
		$CanvasLayer/BossBar.visible = false
		$CanvasLayer/Camera2D/AnimationPlayer.play("end_anim")
		yield(get_tree().create_timer(5.0), "timeout")
		win(false)


func _on_DynamicJoystick_pressed():
	Globals.dynamic_joystick = $CanvasLayer/Tutorial/DynamicJoystick.pressed
	if Globals.dynamic_joystick:
		Globals.joystick.joystick_mode = JoystickMode.DYNAMIC
	else: Globals.joystick.joystick_mode = JoystickMode.FIXED
	Globals.save_game()
	
