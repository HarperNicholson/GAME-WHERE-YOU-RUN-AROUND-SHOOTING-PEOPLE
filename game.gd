extends Node2D

var world_size : Vector2i = Vector2i(4096,4096)

var enemy_team : TEAM = TEAM.NONE

enum TEAM { NONE, AGENTS, ALIENS}

var survival_time : float = 0.0



func _ready() -> void:
	
	EffectManager.PersistentEffectsTopNode = $PersistentEffectsTop/Node2D
	EffectManager.PersistentEffectsMiddleNode = $PersistentEffectsMiddle/Node2D
	EffectManager.PersistentEffectsBottomNode = $PersistentEffectsBottom/Node2D
	
	EffectManager.TempBottomEffectsNode = $TempBottomEffects
	EffectManager.TempTopEffectsNode = $TempTopEffects
	EffectManager.TempTopTopEffectsNode = $TempTopTopEffects
	
	EffectManager.AudioPool = $AudioPool
	
	EffectManager._initialize_audio_pool()
	
	$PersistentEffectsTop.size = world_size
	$PersistentEffectsMiddle.size = world_size
	$PersistentEffectsBottom.size = world_size
	
	@warning_ignore("integer_division")
	$PersistentEffectsTopTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentEffectsMiddleTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentEffectsBottomTexture.position = world_size / 2
	
	spawn_player()

func _physics_process(delta: float) -> void:
	survival_time += delta
	
	Global.difficulty = 1.0 + (survival_time / 60.0) * 0.25

func spawn_player():
	#global_position = world_size / 2
	#instantiate and set player = instance etc
	#but for now
	Global.player = get_tree().get_first_node_in_group("Player")

func spawn_object(object_instance):
	$GameObjects.call_deferred("add_child", object_instance)
