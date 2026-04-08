#should extend Projectile class surely
extends Area2D

var speed : float = 600.0
var direction : Vector2 = Vector2.RIGHT
var knockback : float = 50.0

func _physics_process(delta):
	position += direction * speed * delta

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Civilian:
		body.hit()
		body.add_impulse(direction * knockback)
		queue_free()
