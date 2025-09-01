extends Area2D

class_name Potion

@export var heal_amount: float = 20.0  # ปริมาณเลือดที่จะเด้ง
signal picked_up
var velocity: Vector2 = Vector2.ZERO
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.health_node.heal(heal_amount)  # ใช้ฟังก์ชัน heal ใน Health.gd
		picked_up.emit()
		queue_free()  # ลบโพชั่นออกเมื่อถูกเก็บ
