extends Node

var once = true

var game_manager
var player_cam
var menu_cam

var sfx_manager
var trajectory
var trajectory_dot

var spawner
var health_system
var arrow_ammo_system

var arrows = 0
var get_arrow_time = 5
var ammo = 2 #diffuculty

var game_mode
var waves_count = 3 #difficulty
var wave = 1
var remaining_enemies = 0
var max_enemy_count = 10 #difficulty
var min_enemy_count = 3 #difficulty
var max_enemy_plus = 3 #difficulty
var min_enemy_plus = 2 #difficulty
var spawn_time_minus = 0.2 # difficulty

var highscore

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
	
	highscore = data["player"]["score"]
	
	file.close()


func save_game():
	var file
	
	file = File.new()
	
	file.open(path, File.WRITE)
	
	file.store_line(to_json(data))
	
	file.close()


func reset_data():
	# Reset to defaults
	data = default_data.duplicate(true)
