extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	Engine.max_fps = 120


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
