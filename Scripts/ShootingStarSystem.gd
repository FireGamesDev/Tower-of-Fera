extends Node2D

const starScene = preload("res://Scenes/ShootingStar.tscn")

var star
var force
var rng = RandomNumberGenerator.new()

var distance
var direction = Vector2(1, -1)
var shoot_force = 0.5

func _ready():
	$Timer.start(rng.randf_range(5,20))

func _on_Timer_timeout():
	star = starScene.instance()
	
	distance = rng.randi_range(1000,2000)
	force = direction * distance * shoot_force
	
	star.life_time = rng.randf_range(0.3,1.2)
	star.mass = rng.randf_range(0.02, star.life_time / 2)
	var rand = rng.randi_range(1,11)
	if rand == 1:
		$SpawnPoint.add_child(star)
	elif rand == 2:
		$SpawnPoint1.add_child(star)
	elif rand == 3: 
		$SpawnPoint2.add_child(star)
	elif rand == 4:
		$SpawnPoint3.add_child(star)
	elif rand == 5:
		$SpawnPoint4.add_child(star)
	elif rand == 6: 
		$SpawnPoint5.add_child(star)
	elif rand == 7:
		$SpawnPoint6.add_child(star)
	elif rand == 8:
		$SpawnPoint7.add_child(star)
	elif rand == 9: 
		$SpawnPoint8.add_child(star)
	elif rand == 10:
		$SpawnPoint9.add_child(star)
	elif rand == 11:
		$SpawnPoint10.add_child(star)
	var width = rng.randi_range(3,14)
	star.launch(force, distance, width)
	
	$Timer.start(rng.randf_range(5,20))
