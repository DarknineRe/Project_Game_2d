class_name Monster
extends CharacterBody2D

signal damaged(attack: Attack)

@export var chase_radius := 1000.0
@export var chase_speed := 100.0
@export var attack_range := 75.0
@export var follow_radius := 25.0

var is_attacking := false
var alive := true
var stunned := false
var stun_time := 1.5
var knockback_force := 200.0
var knockback_velocity: Vector2 = Vector2.ZERO

@onready var health: Health = $Health
@onready var hp_bar:= $Hpbar
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var damage_number_position = $DamageNumbersPosition
@onready var attack_node := $MonsterStateMachine/Attack

func _ready() -> void:
	hp_bar.hide()
	difficulty()
	print("%d Hp"%health.max_health)


func on_damaged(attack: Attack) -> void:
	hp_bar.show()
	DamageNumbers.display_number(attack.damage,damage_number_position.global_position,attack.is_crit)
	damaged.emit(attack)
	
func difficulty():
	var p = player
	health.increase_max_health((p.exp_bar.level-1)* 20 + p.game_time - 1)
	attack_node.damage_attack += p.exp_bar.level
