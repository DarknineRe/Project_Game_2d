extends BossState
 
func enter():
	super.enter()
	animation_player.play("death")
	await animation_player.animation_finished
	var p = get_tree().get_first_node_in_group("Player") as Player
	if p:
		p.add_score(1000)
	owner.queue_free()
