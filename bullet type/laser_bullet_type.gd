class_name LaserBulletType

extends Node2D

@export var damage : float
@export var range : float = 10000.0 #this is for jus testing
@export var beam_duration := 0.5

@onready var raycast = $RayCast2D
@onready var line = $Line2D

func _ready():
	raycast.enabled = true
	raycast.target_position = ((get_global_mouse_position()).normalized()) * range

	await get_tree().process_frame 
	
	if raycast.is_colliding():
		print(raycast.get_collider())
		var area = raycast.get_collider()
		if area is Hitbox:
			var attack := Attack.new()	
			attack.damage = 10	
			area.damage(attack)
			#hit_enemy.emit()
	
	#draw da beam
	line.add_point(Vector2.ZERO) 
	line.add_point(raycast.target_position)
	await get_tree().create_timer(beam_duration).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	if raycast.is_colliding():
		print("bam")
		var area = raycast.get_collider()
		if area is Hitbox:
			var attack := Attack.new()	
			attack.damage = 10	
			area.damage(attack)
			#hit_enemy.emit()
