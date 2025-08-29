extends Control

signal opened
signal closed
signal slot_changed(index: int, item: ItemStackui)

var isOpen: bool = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var ItemStackuiClass = preload("res://Scripts/inventory/itemsStackui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackui = null
var oldIndex: int = -1

func _ready():
	add_to_group("inventory_ui")
	connectSlots()
	inventory.updated.connect(update)
	update()

# Connect slot buttons
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		slot.inventory = inventory
		var callable = Callable(self, "onSlotClicked").bind(slot)
		slot.pressed.connect(callable)

# Update slot visuals from inventory
func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		var slot = slots[i]

		if !inventorySlot.item:
			if slot.itemStackui:
				slot.takeItem()
			continue

		var itemStackui: ItemStackui = slot.itemStackui
		if !itemStackui:
			itemStackui = ItemStackuiClass.instantiate()
			slot.insert(itemStackui)

		itemStackui.inventorySlot = inventorySlot
		itemStackui.update()

# Open/close
func open():
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()

func _on_closed() -> void:
	get_tree().paused = false

func _on_opened() -> void:
	get_tree().paused = true

# Slot clicked
func onSlotClicked(slot):
	if itemInHand:
		if slot.isEmpty():
			insertItemInSlot(slot)
		else:
			swapItem(slot)
	else:
		if !slot.isEmpty():
			takeItemFromSlot(slot)

	# Example: only care about slot 0 changes
	if slot.index == 0:
		emit_signal("slot_changed", slot.index, slot.itemStackui)

# Pick item from slot
func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	oldIndex = slot.index

# Put item into slot
func insertItemInSlot(slot):
	if !itemInHand:
		return
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	oldIndex = -1

# Swap hand item with slot item
func swapItem(slot):
	var tempItem = slot.takeItem()
	insertItemInSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

# Keep dragged item under mouse
func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func _process(_delta):
	updateItemInHand()

# Return item to old slot or first empty
func putItemBack():
	if !itemInHand:
		return

	if oldIndex < 0:
		var emptySlots = slots.filter(func(s): return s.isEmpty())
		if emptySlots.is_empty(): 
			return
		oldIndex = emptySlots[0].index

	var targetSlot = slots[oldIndex]
	insertItemInSlot(targetSlot)

# Input handling
func _input(_event):
	if itemInHand and Input.is_action_just_pressed("Cancel"): # fixed typo
		putItemBack()
