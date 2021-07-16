extends Node

var once = true

var game_manager
var player_cam
var menu_cam
var joystick
var on_drag = false

var is_ended = false

var sfx_manager
var trajectory
var trajectory_dot

var star_vignette

var spawner
var health_system
var arrow_ammo_system
var can_shoot = false

var arrows = 0
var get_arrow_time = 5 #difficulty
var ammo = 2 #difficulty

var game_mode
var waves_count = 3 #difficulty
var wave = 1
var remaining_enemies = 0
var max_enemy_count = 10 #difficulty
var min_enemy_count = 3 #difficulty
var max_enemy_plus = 3 #difficulty
var min_enemy_plus = 2 #difficulty
var spawn_time_minus = 0.2 #difficulty
var health_spawn_max = 20 #diffuculty
var spawner_spawn_time #diffuculty
var spawner_tank_health #diffuculty
var spawner_enemy_speed #diffuculty

var train_timer
var train_point

var boss

var menu_button_in_game

var path = "user://data.save"

#things to save:
var wave_save
var easy_save
var normal_save
var hard_save
var endless_wave_save
var boss_save
var volume
var muted
var story
var dynamic_joystick

func save_game():
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_var(wave_save)
	f.store_var(easy_save)
	f.store_var(normal_save)
	f.store_var(hard_save)
	f.store_var(endless_wave_save)
	f.store_var(boss_save)
	f.store_var(volume)
	f.store_var(muted)
	f.store_var(story)
	f.store_var(dynamic_joystick)
	f.close()

func load_game():
	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		wave_save = f.get_var()
		easy_save = f.get_var()
		normal_save = f.get_var()
		hard_save = f.get_var()
		endless_wave_save = f.get_var()
		boss_save = f.get_var()
		volume = f.get_var()
		muted = f.get_var()
		story = f.get_var()
		dynamic_joystick = f.get_var()
		f.close()
	else: reset_data()
		
func reset_data():
	wave_save = 0
	easy_save = false
	normal_save = false
	hard_save = false
	endless_wave_save = 0
	boss_save = false
	volume = -7
	muted = false
	story = true
	dynamic_joystick = false
	save_game()
		
func save_score(score):
	wave_save = score
	if wave_save > endless_wave_save:
		endless_wave_save = wave_save
	save_game()
	
func save_progress():
	if game_mode == "Easy":
		easy_save = true
	if game_mode == "Normal":
		normal_save = true
	if game_mode == "Hard":
		hard_save = true
	if game_mode == "Boss":
		boss_save = true
	save_game()

func save_endless_score(score):
	endless_wave_save = score
	save_game()
