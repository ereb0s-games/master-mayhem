extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Globals.PlrHealth = 0
	else:
		get_tree().queue_delete(body)
