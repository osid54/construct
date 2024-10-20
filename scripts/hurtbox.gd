extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print(body.collision_layer)
	if body.collision_layer == 1:
		body.hit()
