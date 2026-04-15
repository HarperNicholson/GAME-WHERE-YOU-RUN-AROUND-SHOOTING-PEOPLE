extends Sprite2D

# --- Physics ---
var vel := Vector2.ZERO
var z := 0.0
var vz := 0.0
var gravity := 1000.0
var base_position := Vector2.ZERO
var ground_y := 0.0

var rot_v := 0.0
var landed := false

# --- Shadow ---
var shadow : Sprite2D

var lifetime : float = 30.0
var elapsed_lifetime : float = 0.0

func _ready():
	base_position = position
	ground_y = base_position.y + randf_range(-2, 3)
	
	shadow = Sprite2D.new()
	shadow.texture = texture
	shadow.modulate = Color(0,0,0,0.2)
	shadow.scale = Vector2(1.2, 0.6) #squashed shadow look
	shadow.z_index = -1
	get_parent().add_child(shadow)
	_update_shadow()  # place initially

func _process(delta):
	elapsed_lifetime += delta
	
	if elapsed_lifetime >= lifetime:
		elapsed_lifetime = 0.0
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
		tween.parallel().tween_property(shadow, "modulate:a", 0.0, 1.0)
		tween.tween_callback(func(): shadow.queue_free(); self.queue_free())
	
	if landed:
		return
	
	position = base_position - Vector2(0, z * 0.5)
	rotation += rot_v * delta
	
	_update_shadow()

func _physics_process(delta):
	if landed:
		return
	
	vel *= 0.99
	base_position += vel * delta
	
	vz -= gravity * delta
	z += vz * delta
	
	vel.x += randf_range(-10, 10) * delta
	
	if z <= 0:
		z = 0
		base_position.y = ground_y
		land()

func _update_shadow():
	var height_factor = clamp(z / 300.0, 0.0, 1.0)
	
	shadow.global_position = base_position + Vector2(0,0.5)
	
	shadow.scale = 4.0 * Vector2(
		1.2 + 0.6 * height_factor,
		0.6 + 0.2 * height_factor
	)
	
	shadow.modulate.a = 0.0#lerp(0.3, 0.1, height_factor)

func land():
	landed = true
	vel = Vector2.ZERO
	rot_v = 0
	rotation = round(rotation / (PI/2)) * (PI/2)
	
	# subtle squash using tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", scale * Vector2(0.85, 0.85), 0.05)
	tween.tween_property(self, "scale", scale, 0.05)
	
	EffectManager.spawn_blood_pool_particle_effect(global_position)
	
	var gp = global_position
	self.reparent(EffectManager.PersistentSolidsNode)
	self.global_position = gp
