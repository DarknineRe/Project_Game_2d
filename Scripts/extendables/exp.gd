extends Area2D

@export var experience := 1
@export var collect_distance := 200.0   # auto-collect radius
@export var collect_speed := 200.0      # move speed toward player

var player : CharacterBody2D = null
var is_collecting := false

func _ready() -> void:
	# Find the player in the scene tree (adjust if your player is named differently)
	player = get_tree().get_first_node_in_group("Player") 

func _process(delta: float) -> void:
	if not player:
		return

	var dist = global_position.distance_to(player.global_position)

	# Start auto-collect if close enough
	if dist <= collect_distance:
		is_collecting = true
	if dist > collect_distance:
		is_collecting = false
	# Move toward player while collecting
	if is_collecting:
		global_position = global_position.move_toward(player.global_position, collect_speed * delta)

		# When close enough, "collect" the orb
		if dist < 50:
			_collect()

func _collect() -> void:
	# Tell the player to gain EXP
	player.exp_bar.add_exp(experience)
	queue_free()
