extends BossState
 
@export var pivot : Node2D
var can_transition: bool = false
 
func enter():
	super.enter()
	await play_animation("laser_cast")
	set_target()
	await play_animation("laser")
	can_transition = true
 
func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished
 
func set_target():
	pivot.look_at(player.position)
 
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")

func attack_hit(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var attack = Attack.new()
		attack.damage = boss.attack_damage * 0.9
		body.damage(attack)
