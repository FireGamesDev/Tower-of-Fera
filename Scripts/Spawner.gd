extends Node2D

const flying_enemy = preload("res://Scenes/FlyingEnemy.tscn")
const ground_enemy1 = preload("res://Scenes/GroundEnemy1.tscn")
const ground_enemy2 = preload("res://Scenes/GroundEnemy2.tscn")
const ground_enemy3 = preload("res://Scenes/GroundEnemy3.tscn")

#diffuculty
var spawn_time = 4
var enemy_speed = 50
var tank_health = 2

var wait_time = 5

var total_enemies_count
var current_enemy_count = 0


func _ready():
	Globals.spawner = self
	yield(get_tree().create_timer(1.0), "timeout") #wait to get the game_manager initialize
	next_wave()
	
func spawn_wave():
	Globals.max_enemy_count += Globals.max_enemy_plus
	Globals.min_enemy_count += Globals.min_enemy_plus
	total_enemies_count = randi()%Globals.max_enemy_count + Globals.min_enemy_count
	Globals.remaining_enemies = total_enemies_count
	set_remaining_text()
	spawn_time -= Globals.spawn_time_minus
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
	if current_enemy_count < total_enemies_count:
		spawn()
		current_enemy_count += 1
		$Timer.start(spawn_time)
		
func next_wave():
	if Globals.wave == Globals.waves_count + 1:
		Globals.game_manager.win()
		return
		
	var text = "NEXT"
	if Globals.wave == 1:
		text = "FIRST"
	if Globals.wave == Globals.waves_count:
		text = "LAST"
	if Globals.game_manager:
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]" + text + " WAVE IN 5"
		yield(get_tree().create_timer(1.0), "timeout")
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]" + text + " WAVE IN 4"
		yield(get_tree().create_timer(1.0), "timeout")
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]" + text + " WAVE IN 3"
		yield(get_tree().create_timer(1.0), "timeout")
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]" + text + " WAVE IN 2"
		yield(get_tree().create_timer(1.0), "timeout")
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]" + text + " WAVE IN 1"
		yield(get_tree().create_timer(1.0), "timeout")
	
	set_wave_text()
	
	Globals.wave += 1
	Globals.remaining_enemies = 0
	current_enemy_count = 0
	spawn_wave()
	
func set_wave_text():
	if Globals.game_manager:
		Globals.game_manager.wave_text.bbcode_text = "\n[wave]WAVE: " + str(Globals.wave) + "/" + str(Globals.waves_count)

func set_remaining_text():
	if Globals.remaining_enemies == 0:
		if Globals.game_manager:
			Globals.game_manager.remaining_text.bbcode_text = ""
		next_wave()
		return
	if Globals.game_manager:
		Globals.game_manager.remaining_text.bbcode_text = "\n[wave]REMAINING: " + str(Globals.remaining_enemies)
