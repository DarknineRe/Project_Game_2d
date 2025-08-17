class_name LaserBulletType
extends Node2D

@export var speed: float = 800.0
@export var lifetime: float = 2.0
@export var damage := 1.0
@export var max_pierce := 1
@export var fire_rate := 0.1


@onready var line := $Line2D

var beam_width = damage*0.05 + max_pierce*2
var beam_range = speed

func _ready():
	
	line.width = beam_width
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.RIGHT * beam_range)
	
	# Use physics space to detect all overlapping enemies
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2.RIGHT.rotated(rotation) * beam_range)
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
