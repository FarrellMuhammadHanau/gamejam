extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		get_parent().emit_signal("add_target", body)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		get_parent().emit_signal("remove_target", body)
