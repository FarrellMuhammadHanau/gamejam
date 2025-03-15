extends Node2D

@export var projection : PackedScene
@onready var level = get_parent().get_parent().level
signal spawn(Node2D)

func _on_spawn(target : Node2D) ->void:
	var spawned = projection.instantiate()
	spawned.set_target(target)
	spawned.set_level(level)
	get_tree().get_root().add_child(spawned)
	spawned.global_position = global_position
