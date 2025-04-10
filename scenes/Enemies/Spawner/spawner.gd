extends Node2D

@export var variance : Vector2
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")
var enemies = []

# Format Input: Scene, Time
func load_enemies(en):
	enemies = en

func spawn_enemies():
	for enemy in enemies:
		var enemy_scene : PackedScene = enemy[0]
		var timer : float = enemy[1]
		await get_tree().create_timer(timer).timeout
		
		var enemy_instance = enemy_scene.instantiate()
		misc_layer.add_child(enemy_instance)
		enemy_instance.global_position = global_position + variance
