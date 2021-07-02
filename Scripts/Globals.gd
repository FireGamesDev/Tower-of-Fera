extends Node

var once = true

var game_manager
var player_cam
var menu_cam
var waves = 3

var sfx_manager
var trajectory
var trajectory_dot

var spawner
var health_system
var arrow_ammo_system

var arrows = 0
var get_arrow_time = 5
var ammo = 2 #diffuculty

var highscore

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
	
	highscore = data["score"]
	
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
