extends Area2D

var l := 1

func _process(delta: float) -> void:
	$Sprite2D.rotate(-l * 2 * TAU * delta)

func throw(left: bool, player: Node2D):
	if left:
		l = -1
	$Sprite2D.flip_h = left
	$Sprite2D/Sprite2D.flip_h = left
	$Sprite2D/Sprite2D/Sprite2D.flip_h = left
	$Sprite2D.offset.x = l * 11
	$Sprite2D/Sprite2D.offset.x = l * 11
	$Sprite2D/Sprite2D/Sprite2D.offset.x = l * 11
	handleMon()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"position",position+Vector2(256*l,0),.5)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"position",player.global_position,.5)
	tween.set_parallel(true)
	tween.tween_property(self,"modulate",Color(1,1,1,0),.5)
	await get_tree().create_timer(1).timeout
	queue_free()

func handleMon():
	await get_tree().create_timer(.5).timeout
	set_deferred("monitorable", false)
	set_deferred("monitoring", false)
