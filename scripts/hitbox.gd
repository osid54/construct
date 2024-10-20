extends Area2D

func _on_area_entered(_area: Area2D) -> void:
	get_parent().die()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(get_parent(),"modulate",Color(1,1,1,0),.5)
	await get_tree().create_timer(.5).timeout
	get_parent().queue_free()
