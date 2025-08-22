extends Panel

class_name ItemStackui
@onready var itemSprite: Sprite2D = $item
@onready var amountLebel: Label = $Label
var inventorySlot: InventorySlot

func update():
	if !inventorySlot || !inventorySlot.item: return
	itemSprite.visible = true
	itemSprite.texture = inventorySlot.item.texture
	if inventorySlot.amount > 1:
		amountLebel.visible = true
		amountLebel.text = str(inventorySlot.amount)
	else:
		amountLebel.visible = false
