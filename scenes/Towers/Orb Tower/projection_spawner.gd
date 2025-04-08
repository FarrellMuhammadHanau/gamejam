extends Node2D

@export var projection : PackedScene
signal spawn(Node2D)

func _on_spawn(target : Node2D) ->void:
	var spawned = projection.instantiate()
	spawned.set_target(target)
	get_tree().get_root().add_child(spawned)
	spawned.global_position = global_position
