extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	Engine.max_fps = 120
