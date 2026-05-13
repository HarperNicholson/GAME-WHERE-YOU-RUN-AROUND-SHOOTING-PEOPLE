extends Node2D

@export var enemy_scene : PackedScene

var elite_chance : float = 0.0

var spawn_budget : float = 0.0
var spawn_rate : float = 1.0
var max_enemies : int = 120
var recycle_timer : float = 0.0

func _process(delta: float) -> void:
	recycle_timer += delta
	
	if recycle_timer >= 0.5:
		recycle_timer = 0.0
		recycle_far_enemies()
	
	#difficulty-scaled spawn income
	spawn_budget += delta * spawn_rate * Global.difficulty
	
	var enemy_count := get_tree().get_nodes_in_group("Enemies").size()
	
	while spawn_budget >= 1.0 and enemy_count < max_enemies:
		spawn_enemy()
		
		spawn_budget -= 1.0
		enemy_count += 1

func get_spawn_position() -> Vector2:
	var half := Vector2(190, 120)
	
	match randi() % 4:
		0:
			return Global.player_position + Vector2(
				randf_range(-half.x, half.x),
				-half.y
			)
		
		1:
			return Global.player_position + Vector2(
				randf_range(-half.x, half.x),
				half.y
			)
		
		2:
			return Global.player_position + Vector2(
				-half.x,
				randf_range(-half.y, half.y)
			)
		
		_:
			return Global.player_position + Vector2(
				half.x,
				randf_range(-half.y, half.y)
			)

func spawn_enemy():
	
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = get_spawn_position()
	enemy.set_civilian_body_type(Global.enemy_team)
	enemy.max_hp *= Global.difficulty
	enemy.hp = enemy.max_hp
	enemy.damage_mod += Global.difficulty - 1.0
	enemy.xp_reward = round(enemy.xp_reward * pow(Global.difficulty, 0.35))
	
	elite_chance = min(
	0.02 + (owner.survival_time / 600.0),
	0.25
	)
	
	if randf() < elite_chance:
		make_elite(enemy)
	
	
	
	get_tree().get_current_scene().find_child("GameObjects").add_child(enemy)

func make_elite(enemy):
	enemy.elite = true
	
	enemy.size_mod += 0.5 #50%
	
	enemy.max_hp *= 4.0
	enemy.hp = enemy.max_hp
	
	enemy.damage_mod += 1.0
	
	enemy.speed *= 0.8
	
	enemy.xp_reward *= 3
	
	enemy.update_body_size()

func recycle_far_enemies():
	var max_dist := 240.0
	var max_dist_sq := max_dist * max_dist
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.global_position.distance_squared_to(Global.player_position) > max_dist_sq:
			enemy.global_position = get_spawn_position()
