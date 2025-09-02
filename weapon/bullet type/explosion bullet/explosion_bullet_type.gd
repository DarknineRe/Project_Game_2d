class_name ExplosionBullet
extends Bullet

@onready var hurtbox = $BulletHitbox/Exlosion_Shape
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D

var current_pierce_count := 0
var direction: Vector2

func _ready() -> void:
	# direction from rotation
	direction = Vector2.RIGHT.rotated(rotation).normalized()

	# auto destroy after lifetime
	await get_tree().create_timer(lifetime).timeout
	if is_inside_tree():
		queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func on_enemy_hit():
	current_pierce_count += 1
	if current_pierce_count >= max_pierce:
		speed = 0 
		if sprite != null:
			sprite.queue_free()
		explosion()

func explosion():
	AudioManager.exlosion_bullet.play()
	anim.play("Explosion")
	await anim.animation_finished
	queue_free()
