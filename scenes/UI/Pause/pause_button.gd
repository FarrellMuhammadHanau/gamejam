extends Node2D

@onready var pause_menu : Control = get_tree().get_current_scene().get_node("CanvasLayer/PauseMenu")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	if is_instance_valid(Global.current_dragabble):
		Global.current_dragabble.queue_free()
		Global.is_holding = false	
		Global.current_dragabble = null
		
	Engine.time_scale = 0
	pause_menu.visible = true
	Global.paused = true
