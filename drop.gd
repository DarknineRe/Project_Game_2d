extends Node

@export var pickup_scene: PackedScene = preload("res://objects/gun object/pickables.tscn")

# Multiple loot tables for different situations
var loot_tables := {

	"default": [
		{
			"type": "scene", 
			"item": preload("res://inventory/items/potion.tscn"), 
			"chance": 0.1},
		{
			"type": "resource", 
			"item": preload("res://resources/weapon tres/guns tres/sniper_rifle.tres"), 
			"chance": 0.01},
		{
			"type": "resource", 
			"item": preload("res://resources/weapon tres/guns tres/Arbitrator.tres"), 
			"chance": 0.01},
		{
			"type": "resource", 
			"item": preload("res://resources/weapon tres/guns tres/bad_pistol.tres"), 
			"chance": 0.01}
	],

	"boss": [
		{
			"type": "resource", 
			"item": preload("res://resources/weapon tres/guns tres/Arbitrator.tres"), 
			"chance": 0.05},
		{
			"type": "resource", 
			"item": preload("res://resources/weapon tres/guns tres/bad_pistol.tres"), 
			"chance": 0.05}
	]
}

func drop_item(position: Vector2, table_name: String = "default") -> void:
	if not loot_tables.has(table_name):
		push_error("Loot table '%s' does not exist!" % table_name)
		return

	var table = loot_tables[table_name]

	for entry in table:
		if randf() <= entry["chance"]:
			match entry["type"]:
				"scene":
					var item = entry["item"].instantiate()
					item.position = position
					
					# random scatter if velocity exists
					if item.has_method("set_velocity"):
						var angle = randf() * PI * 2
						var speed = 100 + randf() * 50
						item.set_velocity(Vector2(cos(angle), sin(angle)) * speed)
					
					add_child(item)
					
				"resource":
					# Create a Pickup node for the resource
					var pickup = pickup_scene.instantiate()
					pickup.position = position
					pickup.weapon = entry["item"]  # assign the resource
					
					# small scatter
					var angle = randf() * PI * 2
					var speed = 50 + randf() * 25
					pickup.position += Vector2(cos(angle), sin(angle)) * speed * 0.01
					
					add_child(pickup)
