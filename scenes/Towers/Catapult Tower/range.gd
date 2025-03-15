extends Area2D

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
