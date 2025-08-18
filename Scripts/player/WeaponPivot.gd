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
	gun_sprite.texture = sprite

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
		use_weapon(gun_sprite.global_position)
		pass

func use_weapon(direction: Vector2):
	if weapon is Gun:
		shoot_bullet(weapon, direction)
	

func shoot_bullet(gun: Gun, direction: Vector2):
	var bullet = gun.bullet_type.instantiate()
	bullet.set_bullet_stat(gun.bullet_speed,gun.bullet_lifetime,
	gun.damage,gun.max_pierce,gun.fire_rate,)
	bullet.position = direction
	bullet.rotation = global_rotation
	
	for strategy in player.upgrades:
		strategy.apply_upgrade(bullet)
		
	get_tree().current_scene.add_child(bullet)
