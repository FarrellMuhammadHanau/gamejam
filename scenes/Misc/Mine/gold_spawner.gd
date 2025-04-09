extends Node2D

@export var gold: PackedScene

signal spawn_gold(amount: int)


func _on_spawn_gold(amount: int) -> void:
	for i in range(amount):
		var variance = Vector2(randi_range(-20, 20), 0)
		var gold_instance = gold.instantiate()
		get_tree().get_root().add_child(gold_instance)
		gold_instance.global_position = global_position + variance
