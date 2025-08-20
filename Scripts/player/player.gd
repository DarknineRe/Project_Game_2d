class_name Player
extends CharacterBody2D

signal respawned
signal damaged(attack: Attack)

var alive = true
var is_running = false #
var has_weapon = false #
var aim_position: Vector2 = Vector2(1, 0)
var stunned = false #

var upgrades : Array[BulletUpgrade] = []

@export var spawn_point: Node2D
@onready var health_node: Health = $Health
@onready var hp_bar = $Camera2D/Hpbar
@onready var anim = $Body
@onready var exp_bar = $Camera2D/ExpBar
@onready var weapon = $WeaponPivot
@onready var Level = $Camera2D/Level



func _ready() -> void:
	hp_bar.init_health(health_node.max_health)
	exp_bar.level_up.connect(_on_level_up)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var half_viewport = get_viewport_rect().size / 2.0
		aim_position = (event.position - half_viewport)


func _physics_process(_delta: float) -> void:
	if not alive:
		
		_play_death_and_respawn()
		return
		
	if exp_bar.level < 100:
		
		Level.text = "LV %d"%exp_bar.level
		
	else:
		
		Level.text = "LV Max"
		
func kill() -> void:
	
	if alive:
		
		_play_death_and_respawn()


func _play_death_and_respawn() -> void:
	alive = false
	anim.play("death")
	await anim.animation_finished

	await get_tree().create_timer(0.1).timeout
	global_position = spawn_point.global_position
	alive = true
	health_node.health = health_node.max_health
	hp_bar.init_health(health_node.max_health)
	emit_signal("respawned")


func on_damaged(attack: Attack) -> void:
	stunned = true
	damaged.emit(attack)


func _on_level_up(new_level: int) -> void:
	print("Player leveled up! Level: ", new_level)
	get_tree().paused = true
	# Load the upgrade UI scene
	var upgrade_scene = preload("res://level_upgrade.tscn")  # adjust path
	var upgrade_ui = upgrade_scene.instantiate()

	# Add it to Camera2D so it appears in screen space
	$Camera2D.add_child(upgrade_ui)

	# Center the panel in the screen using anchors
	if upgrade_ui is Control:
		upgrade_ui.set_scale(Vector2(0.5, 0.5))
		upgrade_ui.anchor_left = 0.5
		upgrade_ui.anchor_top = 0.5
		upgrade_ui.anchor_right = 0.5
		upgrade_ui.anchor_bottom = 0.5
		upgrade_ui.position = Vector2(0, 0)  # center relative to anchors
