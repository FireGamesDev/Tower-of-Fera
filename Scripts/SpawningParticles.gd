extends CPUParticles2D

var spawn_this
var spawn_time = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(spawn_time)


func _on_Timer_timeout():
	call_deferred("add_child", spawn_this)
	emitting = false
