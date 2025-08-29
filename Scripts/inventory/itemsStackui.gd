extends Panel
class_name ItemStackui

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $Label

var inventorySlot: InventorySlot

# Target size for the icon
@export var icon_size: Vector2 = Vector2(92, 92)

func _ready():
	itemSprite.visible = false
	amountLabel.visible = false
	itemSprite.centered = true

func update():
	if !inventorySlot or !inventorySlot.item:
		itemSprite.visible = false
		amountLabel.visible = false
		return

	# Show the icon
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture

	# Keep aspect ratio while fitting icon_size
	var tex_size = itemSprite.texture.get_size()
	if tex_size != Vector2.ZERO:
		var scale_x = icon_size.x / tex_size.x
		var scale_y = icon_size.y / tex_size.y
		var final_scale = min(scale_x, scale_y)  # preserve shape
		itemSprite.scale = Vector2.ONE * final_scale

	# Center icon in slot
	itemSprite.position = size / 2

	# Amount label
	if inventorySlot.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)
		amountLabel.position = Vector2(
			size.x - amountLabel.size.x - 4,
			size.y - amountLabel.size.y - 4
		)
	else:
		amountLabel.visible = false
