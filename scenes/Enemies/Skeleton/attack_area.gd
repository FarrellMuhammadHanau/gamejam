extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Tower"):
		get_parent().emit_signal("reached", body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Tower"):
		get_parent().emit_signal("unreached", body)
