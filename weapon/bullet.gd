class_name Bullet
extends Node2D

var speed: float = 800.0
var lifetime: float = 2.0
var crit_chance: float = 100
var crit_mult: float = 2
var damage: float = 1.0
var max_pierce: int = 1
var fire_rate: float = 0.1


func set_bullet_stat(speed_: float, lifetime_: float, damage_: float, max_pierce_: int, fire_rate_: float, crit_chance_ : float, crit_mult_ : float):
	speed = speed_
	lifetime = lifetime_
	damage = damage_
	max_pierce = max_pierce_
	fire_rate = fire_rate_
	crit_chance = crit_chance_
	crit_mult = crit_mult_
	_on_stats_updated()  


func _on_stats_updated():
	pass
