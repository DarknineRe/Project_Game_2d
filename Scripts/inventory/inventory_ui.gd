extends Control

signal opened
signal closed
signal slot_changed(index: int, item: ItemStackui)##
var isOpen: bool = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var ItemStackuiClass = preload("res://Scripts/inventory/itemsStackui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemStackui
var oldIndex: = -1

func _ready():
	add_to_group("inventory_ui")
	connectSlots()
	inventory.updated.connect(update)
	update()
	
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		slot.inventory = inventory  # assign Inventory ให้ slot
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	#for i in range(slots.size()):
		#if i < inventory.slots.size():
			#slots[i].update(inventory.slots[i])
		#else:
			#slots[i].update(null)
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

func onSlotClicked(slot):
	if itemInHand:
		if slot.isEmpty():
			insertItemInSlot(slot)
		else:
			swapItem(slot)
	else:
		if !slot.isEmpty():
			takeItemFromSlot(slot)
	if slot.index == 0:
		emit_signal("slot_changed", slot.index, slot.itemStackui)
	"""if itemInHand:
		if !itemInHand: return
		insertItemInSlot(slot)
		return
	if !slot.isEmpty():
		takeItemFromSlot(slot)
		return
	swapItem(slot)"""

func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
	oldIndex = slot.index

func insertItemInSlot(slot):
	if !itemInHand:
		return
	var item = itemInHand
	remove_child(itemInHand)
	itemInHand = null
	slot.insert(item)
	oldIndex = -1

func swapItem(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()

func updateItemInHand():
	if !itemInHand: return
	#itemInHand.get_size()
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2

func putItemBack():
	if oldIndex < 0:
		var emptySlots = slots.filter(func (s): return s.isEmpty())
		if emptySlots.is_empty(): return
		oldIndex = emptySlots[0].index
		
	var targetSlot = slots[oldIndex]
	insertItemInSlot(targetSlot)


func _input(_event):
	if itemInHand && Input.is_action_just_pressed("Cancle"):
		putItemBack()
	updateItemInHand()
