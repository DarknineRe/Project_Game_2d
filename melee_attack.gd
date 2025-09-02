extends BossState

func enter():
	super.enter()
	animation_player.play("melee_attack")
 
func transition():
	if owner.direction.length() > 300:
		get_parent().change_state("Follow")

func attack_hit(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var attack = Attack.new()
		attack.damage = boss.attack_damage * 0.4
		body.damage(attack)
