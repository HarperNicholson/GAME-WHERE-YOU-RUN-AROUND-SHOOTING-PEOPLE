extends Node2D

@onready var rotors := [
	$rotor,
	$rotor2,
	$rotor3,
	$rotor4,
]

var rotor_rotation := 0.0
@export var rotor_speed := 20.0

func _physics_process(delta: float) -> void:
	rotor_rotation = wrapf(
		lerpf(rotor_rotation, rotor_rotation + rotor_speed, delta * 8.0),
		-PI,
		PI
	)
	
	for rotor in rotors:
		rotor.rotation = rotor_rotation
