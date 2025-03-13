extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	body = body as CharacterBody2D
	if not body:
		return
	get_parent().emit_signal("add_target", body)

func _on_body_exited(body: Node) -> void:
	body = body as CharacterBody2D
	if not body:
		return
	get_parent().emit_signal("remove_target", body)
