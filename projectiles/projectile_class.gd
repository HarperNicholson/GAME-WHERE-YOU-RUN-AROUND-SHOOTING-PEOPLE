extends Area2D
class_name Projectile

var shooter : Node
var direction : Vector2 = Vector2.RIGHT

var speed : float = 300.0
var knockback : float = 50.0

var damage : float = 0.0

var has_hit : bool = false

const MAX_DIST := 1000.0
const MAX_DIST_SQ := MAX_DIST * MAX_DIST

var bouncy : bool = false

var ricochets : int = 0

var last_hit

var area_mod : float = 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	if bouncy:
		ricochets += 2
		ricochets *= 2
		damage *= 0.25


func _on_body_entered(body):
	if has_hit:
		return
	if body == shooter:
		return
	if body is Civilian:
		has_hit = true
		body.hit(damage)
		body.add_impulse(direction * knockback)
		queue_free()

func distance_cull_check():
	if global_position.distance_squared_to(shooter.global_position) > MAX_DIST_SQ:
		queue_free()
