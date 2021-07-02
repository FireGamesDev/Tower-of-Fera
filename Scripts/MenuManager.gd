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
	set_saved_score()
	
	Globals.menu_cam = $CanvasLayer


func _on_VolumeSlider_mouse_exited():
	$CanvasLayer/Volume/VolumeSlider.release_focus()


func _on_Mute_pressed():
	Globals.sfx_manager.play_sound(click_sound)
	mute()
	
func mute():
	data["options"]["muted"] = $CanvasLayer/Volume/Mute.pressed
	Globals.save_game()
	if $CanvasLayer/Volume/Mute.pressed:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
	else: 
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data["options"]["volume"])
		$CanvasLayer/Volume/VolumeSlider.value = data["options"]["volume"]
	$CanvasLayer/Volume/Mute.pressed = data["options"]["muted"]
	save_game()
	
func set_saved_score():
	load_game()

var path = "user://data.json"

var data = { }

# The default values
var default_data = {
	"player" : {
		"score" : 0,
		"hard" : false,
		"easy" : false,
		"normal" : false
		},
	"options" : {
		"volume" : -7,
		"muted" : false
	}
}

func load_game():
	var file = File.new()
	
	if not file.file_exists(path):
		reset_data()
		return
	file.open(path, file.READ)
	var text = file.get_as_text()
	
	data = parse_json(text)
	
	$CanvasLayer/Volume/VolumeSlider.value = data["options"]["volume"]
	$CanvasLayer/Volume/Mute.pressed = data["options"]["muted"]
	
	if data["options"]["muted"]:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -80)
		data["options"]["volume"] = -80
	else: AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), data["options"]["volume"])
	
	file.close()


func reset_data():
	# Reset to defaults
	data = default_data.duplicate(true)
	
func save_game():
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()


func _on_VolumeSlider_value_changed(value):
	if !once:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
		data["options"]["volume"] = value
		data["options"]["muted"] = false
		$CanvasLayer/Volume/Mute.pressed = false
	else: once = false


func _on_Menu_tree_exited():
	save_game()

func _on_PlayButton_pressed():
	$CanvasLayer/Control2/Lightning._on_Timer_timeout()
	$CanvasLayer/Control2/Lightning.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Train"


func _on_Boss_pressed():
	$CanvasLayer/Modes/Boss/Boss._on_Timer_timeout()
	$CanvasLayer/Modes/Boss/Boss.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Boss"

func _on_Hard_pressed():
	$CanvasLayer/Modes/Hard/Hard_light._on_Timer_timeout()
	$CanvasLayer/Modes/Hard/Hard_light.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Hard"


func _on_Endless_pressed():
	$CanvasLayer/Modes/Endless/Endless_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Endless/Endless_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Endless"


func _on_Normal_pressed():
	$CanvasLayer/Modes/Normal/Normal_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Normal/Normal_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Normal"


func _on_Easy_pressed():
	$CanvasLayer/Modes/Easy/Easy_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Easy/Easy_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)
	
	Globals.game_mode = "Easy"


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
