extends CharacterBody2D


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var sprite = $Sprite2D
@onready var damage_number_position = $DamageNumbersPosition
@onready var health: Health = $Health

var attack_damage = 100

var direction : Vector2
var DEF = 0
 
var alive = true
	
 
func _ready():
	set_physics_process(false)
 
func _process(_delta):
	if !alive:
		find_child("FiniteStateMachine").change_state("Death")
		return
		
	direction = player.position - position
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func on_damaged(attack: Attack) -> void:
	DamageNumbers.display_number(attack.damage,damage_number_position.global_position,attack.is_crit)
	
func difficulty():
	var p = player
	health.increase_max_health((p.exp_bar.level-1)* 10 + p.game_time - 1)
	attack_damage.damage_attack += p.exp_bar.level
