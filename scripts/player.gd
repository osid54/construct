extends CharacterBody2D

var speed := 300.0
var jumpV := -500.0
var minJump := -150.0
var jumped := false
var attacked := false:
	set(value):
		attacked = value
		if attacked == true:
			await get_tree().create_timer(.3).timeout
			attacked = false
var hp := 3
@onready var wrench : PackedScene = preload("res://assets/objects/wrench.tscn")
@onready var hamA : PackedScene = preload("res://assets/objects/hammerAttack.tscn")

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/ColorRect,"modulate",Color(1,1,1,0),.5)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouseL") and not attacked:
		attack("hammer")
		attacked = true
	if Input.is_action_just_pressed("mouseR") and not attacked:
		attack("wrench")
		attacked = true
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		$jumpTimer.start()

	var direction := Input.get_axis("left", "right")
	if direction:
		if direction < 0:
			$Sprite2D.flip_h = true
			
			$handFPath/handFFollow/handF.flip_h = true
			$handFPath/handFFollow/handF.offset.x = 8
			$handFPath/handFFollow/handF/toolF.frame = 27
			$handFPath/handFFollow/handF/toolF.offset = Vector2(-13,-7.625)
			$handFPath/handFFollow/handF/toolF.flip_h = true
			
			$handBPath/PathBFollow/handB.flip_h = true
			$handBPath/PathBFollow/handB.offset.x = 8
			$handBPath/PathBFollow/handB/toolB.frame = 26
			$handBPath/PathBFollow/handB/toolB.offset = Vector2(8,-5.255)
			$handBPath/PathBFollow/handB/toolB.flip_h = true
			
		else:
			$Sprite2D.flip_h = false
			
			$handFPath/handFFollow/handF.flip_h = false
			$handFPath/handFFollow/handF/toolF.frame = 26
			$handFPath/handFFollow/handF.offset.x = -8
			$handFPath/handFFollow/handF/toolF.offset = Vector2(-8,-5.255)
			$handFPath/handFFollow/handF/toolF.flip_h = false
			
			$handBPath/PathBFollow/handB.flip_h = false
			$handBPath/PathBFollow/handB/toolB.frame = 27
			$handBPath/PathBFollow/handB.offset.x = -8
			$handBPath/PathBFollow/handB/toolB.offset = Vector2(13,-7.625)
			$handBPath/PathBFollow/handB/toolB.flip_h = false

		velocity.x = direction * speed
		$AnimationPlayer.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimationPlayer.play("idle")

	if is_on_floor():
		$groundTimer.start()
		jumped = false
	else:
		velocity += get_gravity() * delta

	if !$jumpTimer.is_stopped() and !$groundTimer.is_stopped():
		velocity.y = jumpV
		jumped = true
		$jumpTimer.stop()
		$groundTimer.stop()

	if Input.is_action_just_released("up") and jumped:
		velocity.y = max(minJump,velocity.y)

	move_and_slide()

func attack(type: String):
	var flip = false
	var goalRot := 0.0
	if $handFPath/handFFollow/handF.flip_h:
		flip = true
		$attackHand.position = Vector2(-34,30)
		$attackHand.frame = 9
		$attackHand.rotation = PI/2 - PI/4
		goalRot = PI - PI/4
	else:
		$attackHand.position = Vector2(34,30)
		$attackHand.frame = 8
		$attackHand.rotation = PI/2 + PI/4
		goalRot = PI/4

	$attackHand.visible = true
	$attackHand.flip_v = flip
	$attackHand.flip_h = flip

	$attackHand/tool.flip_v = flip
	if type == "hammer":
		$attackHand/tool.frame = 26
		$attackHand/tool.show_behind_parent = flip
		if !flip:
			$attackHand/tool.offset = Vector2(-8,-7.625)
			$handFPath.visible = false
		else:
			$attackHand/tool.offset = Vector2(-8,5)
			$handBPath.visible = false
		var h = hamA.instantiate()
		add_child(h)
		h.throw(flip)
	if type == "wrench":
		$attackHand/tool.frame = 27
		$attackHand/tool.show_behind_parent = !flip
		if !flip:
			$attackHand/tool.offset = Vector2(13,-7.625)
			$handBPath.visible = false
		else:
			$attackHand/tool.offset = Vector2(13,5)
			$handFPath.visible = false
		if $wTimer.is_stopped():
			var w = wrench.instantiate()
			w.position = global_position
			get_tree().root.add_child(w)
			w.throw(flip,self)
			$wTimer.start()
	
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($attackHand,"rotation",goalRot,.1)
	tween.tween_property($attackHand,"position",$attackHand.position+Vector2(0,-30),.1)
	await get_tree().create_timer(.2).timeout
	$handBPath.visible = true
	$handFPath.visible = true
	$attackHand.visible = false

func hit():
	hp = max(0,hp-1)
	print("hp",hp)
	for i in $CanvasLayer/HBoxContainer.get_child_count():
		if i > hp-1:
			$CanvasLayer/HBoxContainer.get_child(i).visible = false
	if hp == 0:
		var tween = get_tree().create_tween()
		tween.tween_property($CanvasLayer/ColorRect,"modulate",Color(1,1,1,1),.5)
		await get_tree().create_timer(.5).timeout
		get_tree().reload_current_scene()
