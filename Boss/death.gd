extends BossState
 
var ExpOrbScene = preload("res://Scene/exp.tscn")

func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	owner.queue_free()
	
	var total_exp = randi() % 50 + 1
	Drop.drop_item(boss.global_position)
	var values = [50, 10, 5, 1]
	for v in values:
		while total_exp >= v:
			_spawn_orb(v)
			total_exp -= v

func _spawn_orb(exp_value: int) -> void:
	var orb = ExpOrbScene.instantiate()
	orb.global_position = boss.global_position + Vector2(randf()*20-10, randf()*20-10)
	orb._set_experience(exp_value)

	var angle = randf() * PI * 2
	var speed = 100 + randf() * 50
	orb.initial_velocity = Vector2(cos(angle), sin(angle)) * speed

	get_tree().current_scene.add_child(orb)
