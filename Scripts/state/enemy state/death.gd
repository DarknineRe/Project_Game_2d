extends MonsterState

var ExpOrbScene = preload("res://scene/exp.tscn")

# Preload textures
var texture_small = preload("res://Art/weapon/bullet.png")   # 1 EXP
var texture_medium = preload("res://Art/weapon/bullet_blue.png") # 5 EXP
var texture_large = preload("res://Art/weapon/bullet_purple.png")   # 10 EXP

func enter():
	# Random total EXP
	var total_exp = randi() % 25 + 1  # 1-25 EXP

	# Spawn large orbs first
	while total_exp >= 10:
		_spawn_orb(10)
		total_exp -= 10

	# Medium orbs
	while total_exp >= 5:
		_spawn_orb(5)
		total_exp -= 5

	# Small orbs
	while total_exp >= 1:
		_spawn_orb(1)
		total_exp -= 1

	enemy.queue_free()

func _spawn_orb(exp_value: int) -> void:
	var orb = ExpOrbScene.instantiate()
	# Slight random offset so orbs don’t stack
	orb.global_position = enemy.global_position + Vector2(randf()*20-10, randf()*20-10)
	orb.experience = exp_value

	# Set texture based on EXP value
	if exp_value <= 1:
		orb.get_node("Sprite2D").texture = texture_small
	elif exp_value <= 5:
		orb.get_node("Sprite2D").texture = texture_medium
	else:
		orb.get_node("Sprite2D").texture = texture_large

	# Give pop-out velocity
	var angle = randf() * PI * 2
	var speed = 100 + randf() * 50
	orb.initial_velocity = Vector2(cos(angle), sin(angle)) * speed

	get_tree().current_scene.add_child(orb)
