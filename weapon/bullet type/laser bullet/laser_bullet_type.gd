class_name LaserBulletType
extends Bullet

@onready var line := $Line2D



func _ready():
	line.width = get_beam_width()
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * get_beam_range())
	
	# Use physics space to detect all overlapping enemies
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2.RIGHT.rotated(rotation) * get_beam_range())
	query.collide_with_areas = true  # Important for Hitbox detection
	
	var result = space_state.intersect_ray(query)
	
	# Store all hit enemies to avoid damaging them multiple times
	var hit_enemies = []
	
	while result:
		if result.collider is Hitbox and not hit_enemies.has(result.collider):
			var attack := Attack.new()
			attack.damage = damage
			result.collider.damage(attack)
			hit_enemies.append(result.collider)
		
		query.from = result.position + Vector2.RIGHT.rotated(rotation) * 1.0  # Small offset
		result = space_state.intersect_ray(query)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func get_beam_width() -> float:
	return damage * 0.1 + max_pierce * 2

func get_beam_range() -> float:
	return speed
