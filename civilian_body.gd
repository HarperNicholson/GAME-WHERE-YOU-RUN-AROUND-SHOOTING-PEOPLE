extends Node2D

@export var skin_gradient : Gradient
@export var hair_gradient : Gradient

var type : CIVILIAN_TYPE = CIVILIAN_TYPE.NONE

enum CIVILIAN_TYPE {
	NONE = -1,
	POLICE,
	GREEN_ALIEN
}

var anim_time : float = randf() * TAU
var drag_offset : float = 0.0
var tilt_from_velocity : float = 0.0
var was_moving : bool = false

@onready var base_head_y : float = $Head.position.y
@onready var base_pants_y : float = $Pants.position.y
@onready var base_shirt_y : float = $Shirt.position.y


@export var max_running_speed_before_considered_flying : float = 200.0
@export var walking_anim_speed : float = 10.0
@export var running_anim_speed : float = 15.0
@export var walking_anim_swing_speed : float = 0.1
@export var running_anim_swing_speed : float = 1.0
@export var max_hop_speed : float = 12.0
@export var max_hop_anim_height : float = 5.0
@export var max_running_tilt_as_radians : float = 0.25


var prev_velocity_x : float = 0.0
func _ready() -> void:
	if randf() < 0.01: type = CIVILIAN_TYPE.values().pick_random()
	match type:
		CIVILIAN_TYPE.NONE: make_regular_civilian()
		CIVILIAN_TYPE.POLICE: make_police_officer()
		CIVILIAN_TYPE.GREEN_ALIEN: make_green_alien()

func animate(delta, velocity):
	anim_time += delta
	
	var speed = velocity.length()
	var factor = clamp(speed / max_running_speed_before_considered_flying, 0.0, 1.0)
	
	var anim_speed = lerp(walking_anim_speed, running_anim_speed, factor)
	var swing = lerp(walking_anim_swing_speed, running_anim_swing_speed, factor)
	var hop_amp = lerp(0.0, max_hop_anim_height, factor)
	
	var target_drag = clamp(velocity.x * 0.05, -max_running_tilt_as_radians, max_running_tilt_as_radians)
	drag_offset = lerp(drag_offset, target_drag, delta * 10.0)
	tilt_from_velocity = lerp(0.0, drag_offset, factor)
	
	rotation = tilt_from_velocity
	
	
	var moving = factor > 0.01
	
	if moving != was_moving:
		anim_time = 0.0
	
	
	was_moving = moving
	
	
	if moving:
		var t = anim_time * anim_speed
		
		smooth_rot($Pants/LegL, sin(t) + tilt_from_velocity, delta)
		smooth_rot($Pants/LegR, sin(t + PI) + tilt_from_velocity, delta)
		
		smooth_rot($Shirt/ArmL, sin(t) * swing - PI/3 + tilt_from_velocity, delta)
		smooth_rot($Shirt/ArmR, sin(t + PI) * swing + PI/3 + tilt_from_velocity, delta)
	else:
		var breathe = sin(anim_time * 3.0) * 0.20
		
		smooth_rot($Shirt/ArmL, -PI / 3 - breathe, delta)
		smooth_rot($Shirt/ArmR, PI / 3 + breathe, delta)
		
		smooth_rot($Pants/LegL, -PI * 0.05 - breathe / 2, delta)
		smooth_rot($Pants/LegR, PI * 0.05 + breathe / 2, delta)
	
	#HOP
	var wave = sin(anim_time * max_hop_speed)
	
	position.y = -abs(wave) * hop_amp


func smooth_rot(node: Node2D, target: float, delta: float, speed := 15.0):
	node.rotation = lerp(node.rotation, target, delta * speed)



func die(nuked : bool = false):
	
	if nuked:
		print("nuked")
		#ashy stain from nuked
	else:
		EffectManager.spawn_limb($Pants/LegL)
		EffectManager.spawn_limb($Pants/LegR)
		EffectManager.spawn_limb($Shirt/ArmL)
		EffectManager.spawn_limb($Shirt/ArmR)
		EffectManager.spawn_limb($Shirt)
		EffectManager.spawn_limb($Pants)
		EffectManager.spawn_head($Head, $Head/Hair, $Head/Hat)
		
		EffectManager.spawn_blood_splat_particle_effect(global_position)
	queue_free()

func random_color() -> Color:
	var color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	return color

func random_color_from_gradient(grad: Gradient) -> Color:
	return grad.sample(randf())

func make_regular_civilian():
	$Head.self_modulate = random_color_from_gradient(skin_gradient) # roll for rare chance at random color
	$Head/Hair.self_modulate = random_color_from_gradient(hair_gradient)
	$Head/Hair.visible = randf() < 0.9  # 90% chance
	if randf() < 0.03:
		$Head/Hair.self_modulate = random_color()  # weird hair
	$Pants.self_modulate = random_color()
	$Pants/LegR.self_modulate = $Pants.self_modulate
	$Pants/LegL.self_modulate = $Pants.self_modulate
	$Shirt.self_modulate = random_color()
	$Shirt/ArmR.self_modulate = $Shirt.self_modulate
	$Shirt/ArmL.self_modulate = $Shirt.self_modulate
	$Head/Hat.hide()

func make_police_officer():
	$Shirt.self_modulate = Color("224a87")
	$Shirt/ArmR.self_modulate = $Shirt.self_modulate
	$Shirt/ArmL.self_modulate = $Shirt.self_modulate
	$Pants.self_modulate = Color("272727")
	$Pants/LegR.self_modulate = $Pants.self_modulate
	$Pants/LegL.self_modulate = $Pants.self_modulate
	$Head/Hat.self_modulate = Color("224a87")
	$Head/Hat.show()

func make_green_alien():
	$Head.self_modulate = Color.LIME_GREEN
	$Head/Hair.self_modulate = Color.LIME_GREEN
	$Pants.self_modulate = Color.LIME_GREEN
	$Pants/LegR.self_modulate = $Pants.self_modulate
	$Pants/LegL.self_modulate = $Pants.self_modulate
	$Shirt.self_modulate = Color.LIME_GREEN
	$Shirt/ArmR.self_modulate = $Shirt.self_modulate
	$Shirt/ArmL.self_modulate = $Shirt.self_modulate
	$Head/Hat.hide()
	$Head/Eyes.show()
