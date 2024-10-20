extends Area2D

func throw(left: bool):
	$Sprite2D.flip_h = left
	var l = 1
	if left:
		l = -1
	position += Vector2(32*l,0)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(self,"position",position+Vector2(16*l,0),.5)
	tween.tween_property(self,"modulate",Color(1,1,1,0),.5)
	await get_tree().create_timer(.5).timeout
	queue_free()
