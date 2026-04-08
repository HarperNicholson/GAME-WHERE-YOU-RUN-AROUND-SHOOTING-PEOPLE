extends Node2D

@export var skin_gradient : Gradient
@export var hair_gradient : Gradient

var type : CIVILIAN_TYPE = CIVILIAN_TYPE.NONE

enum CIVILIAN_TYPE {
	NONE = -1,
	POLICE,
	GREEN_ALIEN
}

enum ANIMATION_STATE {
	IDLE,
	WALK,
	RUN,
	DEAD
}

var anim_state : ANIMATION_STATE = ANIMATION_STATE.WALK
var anim_time : float = 0.0
var phase_offset := randf() * TAU
var drag_offset := 0.0

@onready var base_head_y : float = $Head.position.y
@onready var base_pants_y : float = $Pants.position.y
@onready var base_shirt_y : float = $Shirt.position.y

func animate(delta, velocity):
	anim_time += delta
	
	var target_drag = clamp(velocity.x * 0.05, -0.25, 0.25)
	drag_offset = lerp(drag_offset, target_drag, delta * 15.0)
	
	
	if is_equal_approx(velocity.length(), 0.0):
		anim_state = ANIMATION_STATE.IDLE
	else:
		anim_state = ANIMATION_STATE.WALK
	
	match anim_state:
		ANIMATION_STATE.IDLE:
			animate_idle(delta)
		ANIMATION_STATE.WALK:
			animate_walk(delta)
		ANIMATION_STATE.RUN:
			animate_run(delta)

func smooth_rot(node: Node2D, target: float, delta: float, speed := 15.0):
	node.rotation = lerp(node.rotation, target, delta * speed)


func animate_walk(delta):
	var t = anim_time * 10.0 + phase_offset
	var swing : float = 0.1
	
	rotation = drag_offset / 2
	
	smooth_rot($Pants/LegL, sin(t) + drag_offset, delta)
	smooth_rot($Pants/LegR, sin(t + PI) + drag_offset, delta)
	
	smooth_rot($Shirt/ArmL, sin(t) * swing - PI/3 + drag_offset, delta)
	smooth_rot($Shirt/ArmR, sin(t + PI) * swing + PI/3 + drag_offset, delta)

func animate_run(delta):
	var t = anim_time * 15.0 + phase_offset
	var swing : float = 1.0
	
	rotation = drag_offset
	
	smooth_rot($Pants/LegL, sin(t) + drag_offset, delta)
	smooth_rot($Pants/LegR, sin(t + PI) + drag_offset, delta)
	
	smooth_rot($Shirt/ArmL, sin(t) * swing - PI/3 + drag_offset, delta)
	smooth_rot($Shirt/ArmR, sin(t + PI) * swing + PI/3 + drag_offset, delta)
	
	animate_hop(delta)

var hop_speed = 12.0
var hop_height = 5.0
func animate_hop(delta):
	var hop = abs(sin(anim_time * hop_speed)) * hop_height
	position.y = -hop
	rotation = lerp(rotation, drag_offset + sin(anim_time * hop_speed) * 1.5, delta * 6.0)



func animate_idle(delta):
	var breathe = sin(anim_time * 3.0) * 0.20
	
	rotation = drag_offset
	position.y = lerp(position.y, 0.0, delta * hop_speed)
	
	smooth_rot($Shirt/ArmL, -PI / 3 - breathe, delta)
	smooth_rot($Shirt/ArmR, PI / 3 + breathe, delta)
	
	smooth_rot($Pants/LegL, -PI * 0.05 - breathe / 2, delta)
	smooth_rot($Pants/LegR, PI * 0.05 + breathe / 2, delta)



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

func random_color():
	var color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	return color

func random_from_gradient(grad: Gradient) -> Color:
	return grad.sample(randf())

func _ready() -> void:
	if randf() < 0.01: type = CIVILIAN_TYPE.values().pick_random()
	match type:
		CIVILIAN_TYPE.NONE: make_regular_civilian()
		CIVILIAN_TYPE.POLICE: make_police_officer()
		CIVILIAN_TYPE.GREEN_ALIEN: make_green_alien()

func make_regular_civilian():
	$Head.self_modulate = random_from_gradient(skin_gradient) # roll for rare chance at random color
	$Head/Hair.self_modulate = random_from_gradient(hair_gradient)
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
