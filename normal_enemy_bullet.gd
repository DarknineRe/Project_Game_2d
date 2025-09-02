class_name EnemyNormalBullet
extends Bullet

@onready var hurtbox = $BulletHitbox
var current_pierce_count := 0
var direction: Vector2

func _ready() -> void:
	# direction from rotation
	AudioManager.shoot_arrow.play()
	direction = Vector2.RIGHT.rotated(rotation).normalized()

	# auto destroy
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func on_enemy_hit():
	current_pierce_count += 1
	if current_pierce_count >= max_pierce:
		queue_free()
