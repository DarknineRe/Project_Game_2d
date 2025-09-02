extends BossState
 
var ExpOrbScene = preload("res://scene/exp.tscn")

func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	owner.queue_free()
	
	var total_exp = randi() % 100 + 200 
	Drop.drop_item(boss.global_position)
	while total_exp >= 10:
		_spawn_orb(10)
		total_exp -= 10
	while total_exp >= 5:
		_spawn_orb(5)
		total_exp -= 5
	while total_exp >= 1:
		_spawn_orb(1)
		total_exp -= 1

func _spawn_orb(exp_value: int) -> void:
	var orb = ExpOrbScene.instantiate()
	orb.global_position = boss.global_position + Vector2(randf()*20-10, randf()*20-10)
	orb._set_experience(exp_value)

	var angle = randf() * PI * 2
	var speed = 100 + randf() * 50
	orb.initial_velocity = Vector2(cos(angle), sin(angle)) * speed

	get_tree().current_scene.add_child(orb)
