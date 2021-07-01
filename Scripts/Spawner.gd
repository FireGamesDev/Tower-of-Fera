extends Node2D

const flying_enemy = preload("res://Scenes/FlyingEnemy.tscn")
const ground_enemy1 = preload("res://Scenes/GroundEnemy1.tscn")
const ground_enemy2 = preload("res://Scenes/GroundEnemy2.tscn")
const ground_enemy3 = preload("res://Scenes/GroundEnemy3.tscn")

#diffuculty
var spawn_time = 4
var enemy_speed = 50
var tank_health = 2


func _ready():
	Globals.spawner = self
	$Timer.start(spawn_time)

func spawn():
	var rand = randi()%4+1
	var enemy
	if rand == 1:
		enemy = ground_enemy1.instance()
		$Ground.call_deferred("add_child", enemy)
	if rand == 2:
		enemy = ground_enemy2.instance()
		$Ground.call_deferred("add_child", enemy)
	if rand == 4:
		enemy = ground_enemy3.instance()
		$Ground.call_deferred("add_child", enemy)
		enemy.health = tank_health
	if rand == 3:
		enemy = flying_enemy.instance()
		var rand1 = randi()%4+1
		if rand1 == 1:
			$Air1.call_deferred("add_child", enemy)
		if rand1 == 2:
			$Air2.call_deferred("add_child", enemy)
		if rand1 == 3:
			$Air3.call_deferred("add_child", enemy)
		if rand1 == 4:
			$Air4.call_deferred("add_child", enemy)
	
	if rand == 4:
		enemy.speed = enemy_speed - 30
	else: enemy.speed = enemy_speed

func _on_Timer_timeout():
	spawn()
	$Timer.start(spawn_time)
