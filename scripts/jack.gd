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

func _process(_delta: float) -> void:
	target = player.position
	if playerInArea:
		$searchArea/RayCast2D.target_position = target - position
		playerFound(null)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
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
		velocity.x = speed * global_position.direction_to(target).x
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
	$face/hurtbox.set_deferred("monitorable", false)
	$face/hurtbox.set_deferred("monitoring", false)
	$hurtbox2.set_deferred("monitorable", false)
	$hurtbox2.set_deferred("monitoring", false)
	speed = 0
