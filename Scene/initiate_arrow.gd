extends MonsterState


var timer : Timer
@export var damage_attack : float = 10

# Upon moving to this state, initialize timer
# and stun enemy
func enter():
	shoot_arrow()


func shoot_arrow():
	
	var arrow = preload("res://normal_enemy_bullet.tscn").instantiate()
	
	arrow.damage = damage_attack
	
	var direction := (player.global_position - enemy.global_position).normalized()
	
	arrow.global_position = enemy.global_position
	arrow.direction = direction
	arrow.rotation = direction.angle() # 🔥 make arrow point towards player
	
	add_child(arrow)
	
