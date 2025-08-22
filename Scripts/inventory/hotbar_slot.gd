extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack_ui: ItemStackui = $CenterContainer/Panel

func update_to_slot(slot: InventorySlot) -> void:
	if !slot.item:
		item_stack_ui.visible = false
		background_sprite.frame = 0
		return

	item_stack_ui.inventorySlot = slot
	item_stack_ui.update()
	item_stack_ui.visible = true
	
	background_sprite.frame = 1

"""extends Button
class_name HotbarSlot

@onready var background_sprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer

var itemStackui: ItemStackui
var index: int
var inventory: Inventory

func insert(item: ItemStackui):
	itemStackui = item
	container.add_child(itemStackui)
	background_sprite.frame = 1
	# เชื่อม slot นี้กับ Inventory
	if inventory and inventory.slots[index] != itemStackui.inventorySlot:
		inventory.insertSlot(index, itemStackui.inventorySlot)

func takeItem() -> ItemStackui:
	var temp = itemStackui
	if itemStackui:
		container.remove_child(itemStackui)
		itemStackui = null
		background_sprite.frame = 0
	return temp

func isEmpty() -> bool:
	return itemStackui == null

func update_to_slot(slot: InventorySlot):
	if slot.item == null:
		if itemStackui:
			container.remove_child(itemStackui)
			itemStackui.queue_free()
			itemStackui = null
		background_sprite.frame = 0
		return
	if !itemStackui:
		itemStackui = preload("res://Scripts/inventory/itemsStackui.tscn").instantiate()
		container.add_child(itemStackui)
	itemStackui.inventorySlot = slot
	itemStackui.update()
	background_sprite.frame = 1"""
