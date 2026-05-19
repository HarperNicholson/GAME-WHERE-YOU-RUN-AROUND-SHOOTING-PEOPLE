extends Node2D

var world_size : Vector2i = Vector2i(4096,4096)

var enemy_team : TEAM = TEAM.NONE

enum TEAM { NONE, AGENTS, ALIENS}

var survival_time : float = 0.0

func _ready() -> void:
	
	EffectManager.PersistentSolidsNode = $PersistentSolids/Node2D
	EffectManager.PersistentShadowsNode = $PersistentShadows/Node2D
	EffectManager.PersistentFlatEffectsNode = $PersistentFlatEffects/Node2D
	
	EffectManager.TempFlatEffectsNode = $TempFlatEffects
	EffectManager.TempSolidEffectsNode = $TempSolidEffects
	EffectManager.TempAirEffectsNode = $TempAirEffects
	
	EffectManager.AudioPool = $AudioPool
	
	EffectManager._initialize_audio_pool()
	
	$PersistentSolids.size = world_size
	$PersistentShadows.size = world_size
	$PersistentFlatEffects.size = world_size
	
	@warning_ignore("integer_division")
	$PersistentSolidsTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentShadowsTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentFlatEffectsTexture.position = world_size / 2
	
	spawn_player()

func _physics_process(delta: float) -> void:
	survival_time += delta
	
	Global.difficulty = 1.0 + (survival_time / 60.0) * 0.25

func spawn_player():
	#global_position = world_size / 2
	#Global.player = playerinstance or wahtever
	#but for now
	Global.player = $GameObjects/RocketAgent
	pass

func spawn_object(object_instance):
	$GameObjects.add_child(object_instance)
