extends Node2D

@export var projection : PackedScene
signal spawn(Node2D, int)

func _on_spawn(target : Node2D, damage : int) ->void:
	var spawned = projection.instantiate()
	spawned.set_target(target)
	spawned.set_damage(damage)
	get_tree().get_root().add_child(spawned)
	spawned.global_position = global_position
