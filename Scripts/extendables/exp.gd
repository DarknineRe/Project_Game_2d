extends Area2D

@export var experience := 1
@export var collect_distance := 200.0
@export var collect_speed := 200.0
@export var lifetime := 10.0
@onready var sprite := $Sprite2D

var player : CharacterBody2D = null
var is_collecting := false

# Pop-out movement
var initial_velocity := Vector2.ZERO
var friction := 400.0

# Preload textures
var texture_small = preload("res://Art/weapon/bullet.png")       # 1 EXP
var texture_medium = preload("res://Art/weapon/bullet_blue.png") # 5 EXP
var texture_large = preload("res://Art/weapon/bullet_purple.png")# 10 EXP
var texture_super_larger = preload("res://Art/weapon/Bullet_Green.png") # 50 EXP

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player") 
	_update_texture()

	# Auto-remove after lifetime
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(_on_lifetime_timeout)

func _on_lifetime_timeout() -> void:
	queue_free()

func _process(delta: float) -> void:
	if not player:
		return

	# Handle pop-out velocity
	if initial_velocity.length() > 0:
		global_position += initial_velocity * delta
		var deceleration = friction * delta
		if initial_velocity.length() <= deceleration:
			initial_velocity = Vector2.ZERO
		else:
			initial_velocity = initial_velocity.move_toward(Vector2.ZERO, deceleration)

	var dist = global_position.distance_to(player.global_position)

	is_collecting = dist <= collect_distance

	if is_collecting:
		global_position = global_position.move_toward(player.global_position, collect_speed * delta)
		if dist < 50:
			_collect()

func _collect() -> void:
	player.exp_bar.add_exp(experience)
	queue_free()

func _set_experience(value: int) -> void:
	experience = value
	_update_texture()

func _update_texture() -> void:
	if not sprite:
		return  # avoids errors if sprite is missing
	if experience <= 1:
		sprite.texture = texture_small
	elif experience <= 5:
		sprite.texture = texture_medium
	elif experience <= 10:
		sprite.texture = texture_large
	else:
		sprite.texture = texture_super_larger
