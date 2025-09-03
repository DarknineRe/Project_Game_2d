extends Node
class_name BossState
 
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var debug = owner.find_child("debug")
@onready var animation_player = owner.find_child("AnimationPlayer")
@onready var boss = get_owner()

func _ready():
	set_physics_process(false)
 
func enter():
	set_physics_process(true)
 
func exit():
	set_physics_process(false)
 
func transition():
	pass
 
func _physics_process(_delta):
	transition()
	debug.text = name
