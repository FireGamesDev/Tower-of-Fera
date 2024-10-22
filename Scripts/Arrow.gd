extends Area2D

const kill_sfx1 = preload("res://SFX/Die1.wav")
const kill_sfx2 = preload("res://SFX/Die2.wav")

const grave1 = preload("res://Scenes/Grave1.tscn")
const grave2 = preload("res://Scenes/Grave2.tscn")
const grave3 = preload("res://Scenes/Grave3.tscn")

const grave1_rigid = preload("res://Scenes/Grave1Rigid.tscn")
const grave2_rigid = preload("res://Scenes/Grave2Rigid.tscn")
const grave3_rigid = preload("res://Scenes/Grave3Rigid.tscn")

var mass = 0.15
var launched = false
var velocity = Vector2(0, 0)

var fade_time = 5
var fade = 1

var current_body

func _physics_process(delta):
	if launched:
		velocity += gravity_direction * gravity * mass
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(initial_velocity : Vector2):
	launched = true
	velocity = initial_velocity.rotated(rotation)

func _on_Arrow_area_shape_entered(_area_id, area, _area_shape, _local_shape):
	if area.is_in_group("Ground"):
		$Anim.play("Arrow_fade")


func _on_Anim_animation_finished(_anim_name):
	queue_free()


func _on_Arrow_body_entered(body):
	if body.is_in_group("Enemy"):
		Globals.arrows += 1
		Globals.arrow_ammo_system.manage_arrows()
		Globals.player_cam.shake(0.5,8,4)
		Globals.health_system.spawn_explosion_particle(body.global_position)
		if randi()%2+1 == 1:
			Globals.sfx_manager.play_kill_sound(kill_sfx1)
		else: Globals.sfx_manager.play_kill_sound(kill_sfx2)
		if !body.is_in_group("FlyingEnemy"):
			spawn_grave(randi()%3 + 1, body.global_position)
		else: spawn_rigid_grave(randi()%3 + 1, body.global_position)
		if Globals.game_mode == "Train":
			body.get_parent().queue_free()
			Globals.train_point += 1
			Globals.game_manager.set_train_score_text()
			return
		body.queue_free()
		Globals.remaining_enemies -= 1
		Globals.spawner.set_remaining_text()
		
	if body.is_in_group("Tank"):
		Globals.player_cam.shake(0.5,8,4)
		if current_body != null:
			if current_body == body:
				return
		current_body = body
		Globals.arrows += 1
		Globals.arrow_ammo_system.manage_arrows()
		if body.health > 1 and Globals.game_mode != "Train":
			$trail_target.queue_free()
			launched = false
			call_deferred("_reparent", self, body)
			position = Vector2(0,0)
			$Anim.set_speed_scale(0.5)
			$Anim.play("Arrow_fade")
		Globals.health_system.spawn_explosion_particle(body.global_position)
		if randi()%2+1 == 1:
			Globals.sfx_manager.play_kill_sound(kill_sfx1)
		else: Globals.sfx_manager.play_kill_sound(kill_sfx2)
		body.health -= 1
		if body.health == 0:
			spawn_grave(randi()%3 + 1, body.global_position)
			if Globals.game_mode == "Train":
				body.get_parent().queue_free()
				Globals.train_point += 1
				Globals.game_manager.set_train_score_text()
				return
			body.queue_free()
			Globals.remaining_enemies -= 1
			Globals.spawner.set_remaining_text()


func _reparent(node, body):
	if node.get_parent() != null:
		node.get_parent().remove_child(node)
	body.add_child_below_node(null, node)
	
func spawn_grave(rand, pos):
	var grave
	if rand == 1:
		grave = grave1.instantiate()
	if rand == 2:
		grave = grave2.instantiate()
	if rand == 3:
		grave = grave3.instantiate()
	Globals.spawner.call_deferred("add_child", grave)
	grave.position = pos
	grave.position.y += 100
	grave.get_child(0).play("grave_appear")
	
func spawn_rigid_grave(rand, pos):
	var grave
	if rand == 1:
		grave = grave1_rigid.instantiate()
	if rand == 2:
		grave = grave2_rigid.instantiate()
	if rand == 3:
		grave = grave3_rigid.instantiate()
	Globals.spawner.call_deferred("add_child", grave)
	grave.position = pos
	grave.position.y += 100
	grave.launch()
	
func play_appear_anim():
	$Anim.play("Arrow_appear")
	
func set_trail_length(value : int):
	$trail_target/Trail.trail_length += value
