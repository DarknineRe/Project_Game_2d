class_name Bullet
extends Node2D

@export var speed: float = 800.0
@export var lifetime: float = 2.0
@export var damage: float = 1.0
@export var max_pierce: int = 1
@export var fire_rate: float = 0.1

func set_bullet_stat(speed_: float, lifetime_: float, damage_: float, max_pierce_: int, fire_rate_: float):
	speed = speed_
	lifetime = lifetime_
	damage = damage_
	max_pierce = max_pierce_
	fire_rate = fire_rate_
	_on_stats_updated()  

func _on_stats_updated():
	pass
