extends CPUParticles2D

var spawn_this
var spawn_time = 6
var current_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(1)


func _on_Timer_timeout():
	current_time += 1
	spread -= 30
	if current_time <= spawn_time:
		$Timer.start(1)
	else:
		call_deferred("add_child", spawn_this)
		emitting = false
