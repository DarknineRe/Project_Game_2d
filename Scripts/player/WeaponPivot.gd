extends Node2D

@export var weapon : Weapon
@export var sprite_offset := Vector2(16, 0) 
#@export var sprite_scale := Vector2.ONE     
#@export var flip_when_left := true  
  
@onready var gun_sprite = $Sprite2D
@onready var sprite = weapon.texture
@onready var player = get_owner()           


var can_shoot := true

func _ready() -> void:
	gun_sprite.position = sprite_offset

func _process(_delta: float) -> void:
	if not player:
		return
	
	var aim_vec = get_global_mouse_position() - player.global_position
	if aim_vec.length() == 0:
		return
	
	global_rotation = aim_vec.angle()
	
	#if flip_when_left:
	gun_sprite.flip_v = (cos(global_rotation) < 0)
	
	if Input.is_action_just_pressed("fire") and can_shoot:
		use_weapon(global_position)
		pass

func use_weapon(direction: Vector2):
	if weapon is Gun:
		shoot_bullet(weapon, direction)
	

func shoot_bullet(gun: Gun, direction: Vector2):
	var bullet = gun.bullet_type.instantiate()
	bullet.position = global_position
	bullet.rotation = global_rotation
	bullet.damage = gun.damage
	bullet.speed = gun.bullet_speed
	bullet.lifetime = gun.bullet_lifetime
	bullet.max_pierce = gun.max_pierce
	bullet.fire_rate = gun.fire_rate
	get_tree().current_scene.add_child(bullet)
