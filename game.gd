extends Node2D

var world_size : Vector2i = Vector2i(1920,1920)

var enemy_team : int = 2

func _ready() -> void:
	
	EffectManager.PersistentSolidsNode = $PersistentSolids/Node2D
	EffectManager.PersistentShadowsNode = $PersistentShadows/Node2D
	EffectManager.PersistentFlatEffectsNode = $PersistentFlatEffects/Node2D
	
	EffectManager.TempFlatEffectsNode = $TempFlatEffects
	EffectManager.TempSolidEffectsNode = $TempSolidEffects
	EffectManager.TempAirEffectsNode = $TempAirEffects
	
	EffectManager.AudioPool = $AudioPool
	
	$PersistentSolids.size = world_size
	$PersistentShadows.size = world_size
	$PersistentFlatEffects.size = world_size
	
	@warning_ignore("integer_division")
	$PersistentSolidsTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentShadowsTexture.position = world_size / 2
	@warning_ignore("integer_division")
	$PersistentFlatEffectsTexture.position = world_size / 2
