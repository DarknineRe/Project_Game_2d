extends Area2D

@export var experience := 1
@export var collect_distance := 200.0
@export var collect_speed := 200.0
@export var lifetime := 10.0  # seconds before disappearing

var player : CharacterBody2D = null
var is_collecting := false

# For pop-out effect
var initial_velocity := Vector2.ZERO
var friction := 400.0  # slows down the pop-out movement

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") 

	# Start timer to auto-remove the orb
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_lifetime_timeout)

func _on_lifetime_timeout() -> void:
	queue_free()  # remove the orb after lifetime expires

func _process(delta: float) -> void:
	if not player:
		return

	# Handle initial pop-out velocity
	if initial_velocity.length() > 0:
		global_position += initial_velocity * delta
		# Apply friction
		var deceleration = friction * delta
		if initial_velocity.length() <= deceleration:
			initial_velocity = Vector2.ZERO
		else:
			initial_velocity = initial_velocity.move_toward(Vector2.ZERO, deceleration)

	var dist = global_position.distance_to(player.global_position)

	if dist <= collect_distance:
		is_collecting = true
	if dist > collect_distance:
		is_collecting = false

	if is_collecting:
		global_position = global_position.move_toward(player.global_position, collect_speed * delta)

		if dist < 50:
			_collect()

func _collect() -> void:
	player.exp_bar.add_exp(experience)
	queue_free()
