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
	"score" : 0,
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


func _on_Hard_pressed():
	$CanvasLayer/Modes/Hard/Hard_light._on_Timer_timeout()
	$CanvasLayer/Modes/Hard/Hard_light.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)


func _on_Endless_pressed():
	$CanvasLayer/Modes/Endless/Endless_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Endless/Endless_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)


func _on_Normal_pressed():
	$CanvasLayer/Modes/Normal/Normal_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Normal/Normal_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)


func _on_Easy_pressed():
	$CanvasLayer/Modes/Easy/Easy_strike._on_Timer_timeout()
	$CanvasLayer/Modes/Easy/Easy_strike.stop = true
	Globals.sfx_manager.play_sound(click_sound)
	SceneChanger.change_scene("res://Scenes/Game.tscn", 0.5)


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
