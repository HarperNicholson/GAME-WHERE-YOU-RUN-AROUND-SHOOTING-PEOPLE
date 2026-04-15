class_name Civilian
extends CharacterBody2D


@export var responsiveness : float = 10.0
@export var always_sprinting : bool = false
@export var is_player : bool = false
var is_alive : bool = true

@export var weapon : Node
@export var controller : Node
@export var playercam : Node

const MOVESPEED : float = 50.0
const SPRINT_MOD : float = 2.0
var hp : int = 3

var elite : bool = false #triple HP, double size, half speed or something

func hit():
	#EffectManager.play_sound_effect("hit")
	EffectManager.spawn_blood_splat_particle_effect(global_position, randi_range(1,3))
	
	flash_color()
	
	hp -= 1
	if hp <= 0 and is_alive:
		kill()

func kill():
	is_alive = false
	$CivilianBody.die()
	$EntityShadow.queue_free()
	$CollisionShape2D.queue_free()
	$Area2D.queue_free()

func attacks():
	var aim_dir = controller.get_aim_direction()
	if aim_dir != Vector2.ZERO:
		weapon.rotation = aim_dir.angle()
	if controller.is_shooting():
		weapon.try_fire()

func _physics_process(delta: float) -> void:
	if !is_alive:
		return

	if is_player:
		attacks()

	movement(delta)
	collisions()
	
	calculate_shadow()
	
	move_and_slide()

func movement(delta):
	var input_dir = controller.get_movement_direction_as_vector()
	var target_velocity = input_dir * MOVESPEED * (SPRINT_MOD if (controller.is_sprinting() or always_sprinting) else 1.0)
	var responsiveness : float = 10.0
	velocity = velocity.move_toward(target_velocity, MOVESPEED * responsiveness * delta)
	
	$CivilianBody.animate(delta, velocity)

func collisions():
	var push : Vector2 = Vector2.ZERO
	var bodies = $Area2D.get_overlapping_bodies()
	var count : int = min(bodies.size(), 6)

	for i in count:
		var other = bodies[i]
		if other == self:
			continue

		#spinning sawblade lol
		#if is_player:
			#if other.is_player == false:
				#other.kill()

		var dir : Vector2 = global_position - other.global_position
		var dist : float = dir.length()
		if dist == 0:
			continue

		var radius := 20.0 # match Area size
		var strength := 1.0 - (dist / radius)
		if strength > 0.0:
			push += (dir / dist) * strength
	
	push = push.limit_length(1.0)
	if push.length() < 0.05:
		push = Vector2.ZERO
	
	add_impulse(push * 10.0)
	
	if push != Vector2.ZERO:
		velocity *= 0.7

func add_impulse(force: Vector2):
	velocity += force

func calculate_shadow():
	var hop_factor : float = clampf(-$CivilianBody.position.y / $CivilianBody.max_hop_anim_height, 0.0, 1.0)
	var default_shadow_scale : Vector2 = Vector2(6.0,3.0)
	var default_shadow_alpha : float = 0.4
	
	$EntityShadow.scale = lerp(default_shadow_scale, default_shadow_scale * 0.7, hop_factor)
	$EntityShadow.self_modulate.a = lerp(default_shadow_alpha, default_shadow_alpha * 0.7, hop_factor)

func flash_color(color_to_flash_to : Color = Color.RED):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", color_to_flash_to, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
