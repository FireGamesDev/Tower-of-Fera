extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.game_manager = self
	
func die():
	pass
	
func win():
	pass


func _on_Tower_body_entered(body):
	if body.is_in_group("Enemy"):
		Globals.health_system.take_damage()
		Globals.health_system.spawn_explosion_particle(body.global_position)
		body.queue_free()
