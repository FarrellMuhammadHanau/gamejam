extends Node2D

@export var variance : Vector2
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
		get_tree().get_root().add_child(enemy_instance)
		enemy_instance.global_position = global_position + variance
