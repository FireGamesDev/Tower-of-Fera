extends Node2D

const flying_enemy = preload("res://Scenes/FlyingEnemy.tscn")
const ground_enemy1 = preload("res://Scenes/GroundEnemy1.tscn")
const ground_enemy2 = preload("res://Scenes/GroundEnemy2.tscn")

var spawn_time = 4
var enemy_speed = 50


func _ready():
	Globals.spawner = self
	$Timer.start(spawn_time)

func spawn():
	var rand = randi()%3+1
	print(rand)
	var enemy
	if rand == 1:
		enemy = ground_enemy1.instance()
		$Position2D.call_deferred("add_child", enemy)
	if rand == 2:
		enemy = ground_enemy2.instance()
		$Position2D.call_deferred("add_child", enemy)
	if rand == 3:
		enemy = flying_enemy.instance()
		$Position2D2.call_deferred("add_child", enemy)
		
	enemy.speed = enemy_speed

func _on_Timer_timeout():
	spawn()
	$Timer.start(spawn_time)
