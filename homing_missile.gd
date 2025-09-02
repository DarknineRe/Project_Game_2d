extends BossState
 
@export var bullet_node: PackedScene
var can_transition: bool = false
 
func enter():
	super.enter()
	animation_player.play("ranged_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true
 
func shoot():
	var bullet = bullet_node.instantiate()
	bullet.damage = boss.attack_damage * 0.5
	bullet.speed = boss.attack_damage * 10
	bullet.position = owner.position
	get_tree().current_scene.add_child(bullet)
 
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
