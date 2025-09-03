extends Bullet
 

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")

var current_pierce_count := 0 

var acceleration: Vector2 = Vector2.ZERO 
var velocity: Vector2 = Vector2.RIGHT.rotated(rotation) * speed

@export var turn_rate_deg: float = 1


func _physics_process(delta):
	if not player: 
		return
		

	# Direction from bullet to player
	var desired_dir = (player.global_position - global_position).normalized()
	var desired_angle = desired_dir.angle()
	var current_angle = velocity.angle()

	# Clamp rotation change to max turn rate
	var max_turn = deg_to_rad(turn_rate_deg) * delta * 60.0 # scale to FPS
	var new_angle = clampf(desired_angle, current_angle - max_turn, current_angle + max_turn)

	# Update velocity based on limited turning
	velocity = speed * Vector2.RIGHT.rotated(new_angle)
	velocity = velocity.limit_length(speed)

	position += velocity * delta

	rotation = velocity.angle()
 
 
func _on_body_entered(_body):
	queue_free()

func on_enemy_hit():
	current_pierce_count += 1
	if current_pierce_count >= max_pierce:
		queue_free()
