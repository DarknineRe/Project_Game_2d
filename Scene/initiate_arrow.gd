extends MonsterState


var timer : Timer
@export var damage_attack : float = 10.0

# Upon moving to this state, initialize timer
# and stun enemy
func enter():
	shoot_arrow()


func shoot_arrow():
	
	print("arrow shot")
	
	var arrow = preload("res://normal_enemy_bullet.tscn").instantiate()
	var direction := player.global_position - enemy.global_position
	arrow.global_position = enemy.global_position
	arrow.direction = (player.global_position - enemy.global_position).normalized()
	
	add_child(arrow)
	
