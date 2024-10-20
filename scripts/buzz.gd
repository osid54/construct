extends CharacterBody2D

var speed := 100
enum state {wander, follow}
var currState := state.wander:
	set(value):
		currState = value
		if value == state.wander:
			speed = 100;
		elif value == state.follow:
			speed = 250;
var targetPos := Vector2()
var targetReached := true
var player
var target := Vector2()
var direction := Vector2()
var playerInArea := false
var travD := 50

func _ready() -> void:
	player = get_tree().root.get_node("main/player")

func _process(delta: float) -> void:
	$saw.rotate(-TAU * delta)
	target = player.position
	if global_position.direction_to(target).x > 0:
		$face.flip_h = true
		$saw.flip_h = true
		$face.offset.x = -18
	else:
		$face.flip_h = false
		$saw.flip_h = false
		$face.offset.x = 18

	if playerInArea:
		$searchArea/RayCast2D.target_position = target - position
		if currState == state.follow:
			$face.rotation = atan((global_position.y-target.y)/(global_position.x-target.x))
		playerFound(null)

func _physics_process(_delta: float) -> void:
	if currState == state.wander:
		if targetReached:
			targetPos = Vector2(position.x+travD,position.y)
			targetReached = false
		else:
			velocity.x = speed * (targetPos.x - position.x)/abs(position.x - targetPos.x)
		if abs(targetPos.distance_to(position)) < 5:
			targetReached = true
			travD *= -1
	if currState == state.follow:
		velocity = speed * global_position.direction_to(target)
	move_and_slide()
	
func playerFound(_body: Node2D) -> void:
	playerInArea = true
	if !$searchArea/RayCast2D.is_colliding():
		currState = state.follow
		targetReached = true
	else:
		currState = state.wander

func playLeft(_body: Node2D) -> void:
	playerInArea = false
	currState = state.wander
	targetReached = true

func die():
	$hurtbox.set_deferred("monitorable", false)
	$hurtbox.set_deferred("monitoring", false)
	speed = 0
