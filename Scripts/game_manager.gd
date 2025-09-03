extends Node2D

@onready var player: Player = $Player
@onready var spawnpoint: Node2D = $spawnpoint

@export var monster_scenes: Array[PackedScene] = [
	preload("res://Scene/monster_archer.tscn"),
	preload("res://Scene/monster.tscn")
]
@export var spawn_mark_scene: PackedScene = preload("res://Scene/spawn_mark.tscn")
@export var spawn_radius: float = 1000.0
@export var min_spawn_distance: float = 100.0
@export var spawn_interval: float = 3.0
@export var max_monsters: int = 10
@export var spawn_delay: float = 1.5   # time to show mark before monster spawns

# Boss settings
@export var boss_scene: PackedScene = load("res://Boss/boss.tscn")
@export var boss_spawn_interval: float = 120.0   # 2 minutes
@export var boss_spawn_delay: float = 2.5        # can be longer than regular monster
var boss_timer := 0.0

var spawn_timer := 0.0

func _ready() -> void:
	AudioManager.bgm.play()
	spawnpoint.position = Vector2.ZERO
	player.spawn_point = spawnpoint
	spawn_timer = spawn_interval
	boss_timer = boss_spawn_interval

func _process(delta: float) -> void:
	# Regular monster spawns
	spawn_timer -= delta
	if spawn_timer <= 0:
		if get_monster_count() < max_monsters:
			spawn_monsters_near_player()
		spawn_timer = spawn_interval

	# Boss spawn
	boss_timer -= delta
	if boss_timer <= 0:
		spawn_boss()
		boss_timer = boss_spawn_interval

func spawn_monsters_near_player() -> void:
	if not player:
		return

	var available_slots = max_monsters - get_monster_count()
	var count_to_spawn = min(randi_range(1, 3), available_slots)

	for i in count_to_spawn:
		spawn_monster_with_delay()

func spawn_monster_with_delay() -> void:
	var angle = randf() * TAU
	var radius = min_spawn_distance + randf() * (spawn_radius - min_spawn_distance)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * radius
	
	var spawn_mark = spawn_mark_scene.instantiate()
	spawn_mark.position = spawn_pos
	add_child(spawn_mark)

	await get_tree().create_timer(spawn_delay).timeout

	var scene = monster_scenes.pick_random()
	var monster = scene.instantiate()
	monster.position = spawn_pos
	monster.add_to_group("Monster")
	add_child(monster)

	spawn_mark.queue_free()

func spawn_boss() -> void:
	if not player:
		return

	# pick a spawn position around player
	var angle = randf() * TAU
	var radius = min_spawn_distance + randf() * (spawn_radius - min_spawn_distance)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * radius
	
	# spawn mark for boss (reuse same effect)
	var spawn_mark = spawn_mark_scene.instantiate()
	spawn_mark.position = spawn_pos
	add_child(spawn_mark)

	await get_tree().create_timer(boss_spawn_delay).timeout

	var boss = boss_scene.instantiate()
	boss.position = spawn_pos
	boss.add_to_group("Boss")
	add_child(boss)

	spawn_mark.queue_free()

func get_monster_count() -> int:
	return get_tree().get_nodes_in_group("Monster").size()
