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
	var enemy
	if rand == 1:
		enemy = ground_enemy1.instance()
		$Ground.call_deferred("add_child", enemy)
	if rand == 2:
		enemy = ground_enemy2.instance()
		$Ground.call_deferred("add_child", enemy)
	if rand == 3:
		enemy = flying_enemy.instance()
		rand = randi()%4+1
		if rand == 1:
			$Air1.call_deferred("add_child", enemy)
		if rand == 2:
			$Air2.call_deferred("add_child", enemy)
		if rand == 3:
			$Air3.call_deferred("add_child", enemy)
		if rand == 4:
			$Air4.call_deferred("add_child", enemy)
		
	enemy.speed = enemy_speed

func _on_Timer_timeout():
	spawn()
	$Timer.start(spawn_time)
