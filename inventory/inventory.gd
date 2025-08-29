extends Resource
class_name Inventory

signal updated

@export var slots: Array[InventorySlot]

# Insert an item into the inventory
func insert(item: InventoryItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	
	updated.emit()

# Remove item at index
func removeItemAtIndex(index: int):
	if index >= 0 and index < slots.size():
		slots[index] = InventorySlot.new()
		updated.emit()

# Insert slot at index, removing it from old position
func insertSlot(index: int, inventory_slot: InventorySlot):
	var old_index: int = slots.find(inventory_slot)
	if old_index != -1:
		removeItemAtIndex(old_index)
	if index >= 0 and index < slots.size():
		slots[index] = inventory_slot
		updated.emit()
