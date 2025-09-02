class_name LaserBulletType
extends Bullet

@onready var line: Line2D = $Line2D
@onready var muzzle_particles: CPUParticles2D = $MuzzleParticles
@onready var impact_particles: CPUParticles2D = $ImpactParticles

func _ready():
	# Beam setup
	line.width = get_beam_width()
	line.texture = _make_gradient_texture()
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH

	# Add glow material
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	line.material = mat

	# Draw base beam
	_update_beam()

	# Play muzzle effect
	muzzle_particles.emitting = true

	# Damage logic
	_fire_ray()

	# Laser lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# --- Update Beam with Wavy Flicker ---
func _process(_delta: float) -> void:
	_update_beam()


func _update_beam() -> void:
	line.clear_points()
	var segments := 25
	for i in range(segments):
		var t := float(i) / float(segments - 1)
		var offset := sin(Time.get_ticks_msec() * 0.02 + t * 30.0) * 2.0
		line.add_point(Vector2(t * get_beam_range(), offset))


# --- Damage Logic ---
func _fire_ray() -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + Vector2.RIGHT.rotated(rotation) * get_beam_range()
	)
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)
	var hit_enemies: Array = []

	while result:
		if result.collider is Hitbox and not hit_enemies.has(result.collider):
			var attack := Attack.new()
			attack.damage = damage
			if randf() <= crit_chance / 100.0:
				attack.is_crit = true
				attack.damage *= crit_mult
			else:
				attack.is_crit = false

			result.collider.damage(attack)
			hit_enemies.append(result.collider)

			# Impact FX
			impact_particles.global_position = result.position
			impact_particles.emitting = true

			# Small camera shake
			_shake_camera()

		# Step forward slightly to check next hit
		query.from = result.position + Vector2.RIGHT.rotated(rotation) * 1.0
		result = space_state.intersect_ray(query)


# --- Beam Appearance ---
func _make_gradient_texture() -> GradientTexture1D:
	var gradient := Gradient.new()
	gradient.colors = [
		Color(1, 0, 0, 0),   # Transparent start
		Color(1, 0, 0, 1),   # Core bright red
		Color(1, 0.5, 0, 0)  # Fade to orange transparent
	]
	var tex := GradientTexture1D.new()
	tex.gradient = gradient
	return tex


# --- Helpers ---
func _shake_camera() -> void:
	var cam := get_tree().current_scene.get_node_or_null("Camera2D")
	if cam and cam.has_method("shake"):
		cam.shake(0.1, 4)  # (duration, intensity)


func get_beam_width() -> float:
	return damage * 0.1 + max_pierce * 2


func get_beam_range() -> float:
	return speed
