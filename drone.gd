extends CharacterBody2D

@onready var rotors := [
	$rotor,
	$rotor2,
	$rotor3,
	$rotor4,
]

var rotor_rotation := 0.0
@export var rotor_speed := 20.0

var weapon : Node

var PlayerControllerNode : Node

func _ready() -> void:
	global_position = Global.player.global_position
	PlayerControllerNode = Global.player.find_child("PlayerController")
	weapon.is_drone_weapon = true
	weapon.drone = self

func _physics_process(delta: float) -> void:
	if Global.paused:
		return
	solve_weapon(delta)
	animate_rotors(delta)
	velocity = velocity.limit_length(290.0)
	move_and_slide()


var aim_dir : Vector2 = Vector2.RIGHT
func solve_weapon(_delta):
	
	weapon.global_position = global_position
	var raw_aim_dir = PlayerControllerNode.get_aim_direction_from_position(global_position)
	
	
	if raw_aim_dir.length() > 0.1:
		aim_dir = aim_dir.lerp(raw_aim_dir, _delta * 10.0)
		
		#var base = aim_dir# * 1.0 + Vector2.UP
		
		if weapon == null:
			return
		
		weapon.rotation = aim_dir.angle()
		
		#cosmetic, weapon scale flip to match facing direction
		if aim_dir.x > 0.1:
			weapon.scale.y = 1.0
		elif aim_dir.x < -0.1:
			weapon.scale.y = -1.0
	
	if PlayerControllerNode.is_shooting():
		weapon.try_fire()

#maybe also animate drone body rotation based on velocity like player
func animate_rotors(delta):
	rotor_rotation = wrapf(
		lerpf(rotor_rotation, rotor_rotation + rotor_speed, delta * 8.0),
		-PI,
		PI
	)
	
	for rotor in rotors:
		rotor.rotation = rotor_rotation

func add_impulse(force: Vector2):
	velocity += force
