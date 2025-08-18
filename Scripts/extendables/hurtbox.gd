class_name Hurtbox
extends Area2D

signal hit_enemy


@onready var projectile = get_owner()


func _ready() -> void:
	area_entered.connect(on_area_entered)
	
	


func on_area_entered(area: Area2D):
	if area is Hitbox:
		var attack := Attack.new()
		attack.damage = projectile.damage
	
		
		if randf() <= projectile.crit_chance/100:
			attack.is_crit = true
			attack.damage *= projectile.crit_mult
		else:
			attack.is_crit = false
		
		area.damage(attack)
		
		hit_enemy.emit()
