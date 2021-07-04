extends Node2D

const click_sound = preload("res://SFX/Collect.wav")

var once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/PlayButton.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Volume/Mute.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Modes/Hard.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Modes/Normal.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Modes/Easy.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Modes/Endless.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Modes/Boss.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Story/ContinueButton.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/Story/Who_is_Fera.set_focus_mode(Control.FOCUS_NONE)
	$CanvasLayer/ThanksForPlaying/CloseButton.set_focus_mode(Control.FOCUS_NONE)
	
	#load the save
	load_game()
	
	Globals.menu_cam = $CanvasLayer


func _on_VolumeSlider_mouse_exited():
	$CanvasLayer/Volume/VolumeSlider.release_focus()


func _on_Mute_pressed():
	Globals.sfx_manager.play_sound(click_sound)
	mute()
	
func mute():
	Globals.muted = $CanvasLayer/Volume/Mute.pressed
	if $CanvasLayer/Volume/Mute.pressed:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else: 
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Globals.volume)
		$CanvasLayer/Volume/VolumeSlider.value = Globals.volume
	$CanvasLayer/Volume/Mute.pressed = Globals.muted
	Globals.save_game()

func load_game():
	Globals.load_game()
	
	#volume
	$CanvasLayer/Volume/VolumeSlider.value = Globals.volume
	$CanvasLayer/Volume/Mute.pressed = Globals.muted
	
	if Globals.muted:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		Globals.volume = -80
	else: AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Globals.volume)
	
	#score
	$CanvasLayer/Modes/Endless/Score.bbcode_text = "\n[wave]BEST: " + str(Globals.endless_wave_save)
	
	#the story show once
	$CanvasLayer/Story.visible = Globals.story
	
	#mode is cleared
	$CanvasLayer/Modes/Easy/Cleared.visible = Globals.easy_save
	$CanvasLayer/Modes/Normal/Cleared.visible = Globals.normal_save
	$CanvasLayer/Modes/Hard/Cleared.visible = Globals.hard_save
	if Globals.hard_save:
		$CanvasLayer/Modes/Boss/Cleared.bbcode_text = "\n[wave]UNLOCKED"
	if Globals.boss_save:
		$CanvasLayer/Modes/Boss/Cleared.bbcode_text = "\n[wave]CLEARED"
		$CanvasLayer/ThanksForPlaying.visible = true
		$CanvasLayer/ThanksForPlaying/CloseButton/Close/AnimationPlayer.play("Appear")


func _on_VolumeSlider_value_changed(value):
	if !once:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
		Globals.volume = value
		Globals.muted = false
		$CanvasLayer/Volume/Mute.pressed = false
	else: once = false


func _on_Menu_tree_exited():
	Globals.save_game()

func _on_PlayButton_pressed():
	$CanvasLayer/Control2/Lightning._on_Timer_timeout()
	$CanvasLayer/Control2/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Train"
	
	Globals.ammo = 2
	Globals.max_enemy_count = 10
	Globals.min_enemy_count = 3
	Globals.max_enemy_plus = 3
	Globals.min_enemy_plus = 2
	Globals.spawn_time_minus = 0.2
	Globals.spawner_spawn_time = 4
	Globals.spawner_enemy_speed = 50
	Globals.spawner_tank_health = 2


func _on_Boss_pressed():
	$CanvasLayer/Modes/Boss/Boss._on_Timer_timeout()
	$CanvasLayer/Modes/Boss/Boss.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Boss"
	
	Globals.spawner_spawn_time = 2
	Globals.spawner_enemy_speed = 100
	Globals.spawner_tank_health = 2
	Globals.health_spawn_max = 10

func _on_Hard_pressed():
	$CanvasLayer/Modes/Hard/Hard_light._on_Timer_timeout()
	$CanvasLayer/Modes/Hard/Hard_light.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Hard"
	
	Globals.ammo = 1
	Globals.get_arrow_time = 60
	Globals.waves_count = 5
	Globals.max_enemy_count = 20
	Globals.min_enemy_count = 10
	Globals.max_enemy_plus = 5
	Globals.min_enemy_plus = 4
	Globals.spawn_time_minus = 0.2
	Globals.spawner_spawn_time = 2
	Globals.spawner_enemy_speed = 75
	Globals.spawner_tank_health = 2
	Globals.health_spawn_max = 10


func _on_Endless_pressed():
	$CanvasLayer/Modes/Endless/Endless_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Endless/Endless_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Endless"
	
	Globals.ammo = 1
	Globals.get_arrow_time = 60
	Globals.spawner_spawn_time = 2
	Globals.spawner_enemy_speed = 50
	Globals.spawner_tank_health = 2
	Globals.health_spawn_max = 10
	Globals.max_enemy_count = 20
	Globals.min_enemy_count = 10
	Globals.max_enemy_plus = 5
	Globals.min_enemy_plus = 4
	Globals.spawn_time_minus = 0.2


func _on_Normal_pressed():
	$CanvasLayer/Modes/Normal/Normal_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Normal/Normal_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	Globals.game_mode = "Normal"
	
	Globals.ammo = 1
	Globals.get_arrow_time = 60
	Globals.waves_count = 4
	Globals.max_enemy_count = 24
	Globals.min_enemy_count = 12
	Globals.max_enemy_plus = 6
	Globals.min_enemy_plus = 5
	Globals.spawn_time_minus = 0.2
	Globals.spawner_spawn_time = 2
	Globals.spawner_enemy_speed = 60
	Globals.spawner_tank_health = 2
	Globals.health_spawn_max = 10


func _on_Easy_pressed():
	$CanvasLayer/Modes/Easy/Easy_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Easy/Easy_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Easy"
	
	Globals.ammo = 1
	Globals.get_arrow_time = 60
	Globals.waves_count = 3
	Globals.max_enemy_count = 10
	Globals.min_enemy_count = 3
	Globals.max_enemy_plus = 3
	Globals.min_enemy_plus = 2
	Globals.spawn_time_minus = 0.2
	Globals.spawner_spawn_time = 4
	Globals.spawner_enemy_speed = 50
	Globals.spawner_tank_health = 2
	Globals.health_spawn_max = 10

func _on_Lightning_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/PlayButton/AnimationPlayer.play("PlayButton")

func _on_Hard_light_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/Modes/Hard/AnimationPlayer.play("PlayButton")

func _on_Endless_strike_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/Modes/Endless/AnimationPlayer.play("PlayButton")

func _on_Normal_strike_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/Modes/Normal/AnimationPlayer.play("PlayButton")

func _on_Easy_strike_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/Modes/Easy/AnimationPlayer.play("PlayButton")


func _on_Boss_strike():
	Globals.menu_cam.shake(0.5,20,14)
	$CanvasLayer/Modes/Boss/AnimationPlayer.play("PlayButton")
	
func on_hard_cleared():
	$CanvasLayer/Modes/Boss/Boss.stop = false
	$CanvasLayer/Modes/Boss.disabled = false


func _on_ContinueButton_pressed():
	#story shows once
	Globals.story = false
	Globals.save_game()
	$CanvasLayer/Story/ContinueButton/Continue._on_Timer_timeout()
	$CanvasLayer/Story/ContinueButton/Continue.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/Story/ContinueButton/Continue/AnimationPlayer.play_backwards("Appear")
	yield(get_tree().create_timer($CanvasLayer/Story/ContinueButton/Continue/AnimationPlayer.current_animation_length), "timeout")
	#start all timers
	$CanvasLayer/Control2/Lightning/Timer.start()
	$CanvasLayer/Modes/Boss/Boss/Timer.start()
	$CanvasLayer/Modes/Easy/Easy_strike/Timer.start()
	$CanvasLayer/Modes/Endless/Endless_strike/Timer.start()
	$CanvasLayer/Modes/Hard/Hard_light/Timer.start()
	$CanvasLayer/Modes/Normal/Normal_strike/Timer.start()
	$CanvasLayer/Story.visible = false


func _on_Continue_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/Story/ContinueButton/AnimationPlayer.play("PlayButton")


func _on_Who_is_Fera_pressed():
	$CanvasLayer/Story/Text.visible = false
	$CanvasLayer/Story/Who_is_Fera.visible = false
	$CanvasLayer/Story/Who_is_fera.visible = true


func _on_Logo_logo_finished():
	$CanvasLayer/Story/ContinueButton/Continue/AnimationPlayer.play("Appear")


func _on_Close_strike():
	Globals.menu_cam.shake(0.5,15,8)
	$CanvasLayer/ThanksForPlaying/CloseButton/AnimationPlayer.play("PlayButton")


func _on_CloseButton_pressed():
	$CanvasLayer/ThanksForPlaying/CloseButton/Close._on_Timer_timeout()
	$CanvasLayer/ThanksForPlaying/CloseButton/Close.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	yield(get_tree().create_timer(1), "timeout")
	$CanvasLayer/ThanksForPlaying/CloseButton/Close/AnimationPlayer.play_backwards("Appear")
	yield(get_tree().create_timer($CanvasLayer/ThanksForPlaying/CloseButton/Close/AnimationPlayer.current_animation_length), "timeout")
	#start all timers
	$CanvasLayer/Control2/Lightning/Timer.start()
	$CanvasLayer/Modes/Boss/Boss/Timer.start()
	$CanvasLayer/Modes/Easy/Easy_strike/Timer.start()
	$CanvasLayer/Modes/Endless/Endless_strike/Timer.start()
	$CanvasLayer/Modes/Hard/Hard_light/Timer.start()
	$CanvasLayer/Modes/Normal/Normal_strike/Timer.start()
	$CanvasLayer/ThanksForPlaying.visible = false
