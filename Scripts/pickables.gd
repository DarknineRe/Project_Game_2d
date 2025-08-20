@tool
class_name Pickup
extends Area2D

@onready var sprite = $Sprite2D
@export var weapon : Weapon:
	set(val):
		weapon = val
		needs_update = true

# Used when editing to denote that the sprite has changed and needs updating
@export var needs_update := false


func _ready() -> void:
	body_entered.connect(on_body_entered)
	sprite.texture = weapon.texture


func _process(_delta: float) -> void:
	# This is run only when we're editing the scene
	if Engine.is_editor_hint():
		if needs_update:
			sprite.texture = weapon.texture
			needs_update = false


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		body.weapon.equip(weapon)
		queue_free()
