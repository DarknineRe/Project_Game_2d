extends MonsterState


var timer : Timer
@export var damage_attack : float = 5

# Upon moving to this state, initialize timer
# and stun enemy
func enter():
	shoot_arrow()
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.autostart = true
	timer.timeout.connect(on_timer_finished)
	add_child(timer)


func shoot_arrow():
	
	var arrow = preload("res://weapon/bullet type/enemy bullet/normal_enemy_bullet.tscn").instantiate()
	
	arrow.damage = damage_attack
	
	var direction := (player.global_position - enemy.global_position).normalized()
	
	arrow.global_position = enemy.global_position
	arrow.direction = direction
	arrow.rotation = direction.angle() # 🔥 make arrow point towards player
	
	add_child(arrow)

# Upon leaving this state, clear and free all
# state relevant stuff
func exit():
	timer.stop()
	timer.timeout.disconnect(on_timer_finished)
	timer.queue_free()
	timer = null


func on_timer_finished():
	if !try_chase():
		transitioned.emit(self, "chase")

func attack_hit(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var attack = Attack.new()
		attack.damage = damage_attack
		body.damage(attack)
