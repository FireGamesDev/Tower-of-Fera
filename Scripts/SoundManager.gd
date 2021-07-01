extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.sfx_manager = self
	
func play_sound(path):
	$SFXPlayer.stream = path
	$SFXPlayer.play()
	
func play_shoot_sound(path):
	$ShootPlayer.stream = path
	$ShootPlayer.play()
	
func play_heal_sound(path):
	$HealPlayer.stream = path
	$HealPlayer.play()
	
func play_kill_sound(path):
	$KillPlayer.stream = path
	$KillPlayer.play()
