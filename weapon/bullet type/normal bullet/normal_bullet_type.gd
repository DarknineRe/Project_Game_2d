extends CharacterBody2D
class_name Bullet

@export var speed: float = 800.0
@export var lifetime: float = 2.0
@export var damage := 80.0
@export var max_pierce := 1
@export var fire_rate := 0.1

@onready var hurtbox = $BulletHitbox

var current_pierce_count := 0
var direction: Vector2

func _ready() -> void:
	# set direction once from rotation
	direction = Vector2.RIGHT.rotated(rotation).normalized()

	# auto destroy after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func on_enemy_hit():
	current_pierce_count += 1
	if current_pierce_count >= max_pierce:
		queue_free()
