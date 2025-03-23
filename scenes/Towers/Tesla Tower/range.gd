extends Area2D

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("Enemy"):
		return
	get_parent().emit_signal("add_target", body)

func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("Enemy"):
		return
	get_parent().emit_signal("remove_target", body)
