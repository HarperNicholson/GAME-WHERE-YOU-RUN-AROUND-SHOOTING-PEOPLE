extends Camera2D

var trauma : float = 0.0
var trauma_decay : float = 3.5

var max_offset := 10.0
var max_rotation := 0.05

func _process(delta):
	trauma = max(trauma - trauma_decay * delta, 0.0)

	var shake := pow(trauma, 0.6) * (1.0 - 0.3 * trauma)

	offset = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	) * max_offset * shake

	rotation = randf_range(-1, 1) * max_rotation * shake

func add_trauma(amount: float):
	trauma = clamp(trauma + amount, 0.0, 1.0)
