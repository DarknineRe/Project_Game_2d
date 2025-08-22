extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var container: CenterContainer = $CenterContainer
@onready var inventory = preload("res://inventory/playerInventory.tres")
var itemStackui: ItemStackui
var index: int

func insert(isg: ItemStackui):
	itemStackui = isg
	backgroundSprite.frame = 1
	container.add_child(itemStackui)
	if !itemStackui.inventorySlot or inventory.slots[index] == itemStackui.inventorySlot:
	#if !itemStackui.inventorySlot || inventory.slots[index] == itemStackui.inventorySlot:
		return
	
	inventory.insertSlot(index, itemStackui.inventorySlot)
	
func takeItem():
	var item = itemStackui
	
	container.remove_child(itemStackui)
	itemStackui = null
	backgroundSprite.frame = 0
	
	return item


func isEmpty():
	return !itemStackui
