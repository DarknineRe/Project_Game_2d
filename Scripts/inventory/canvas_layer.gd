extends CanvasLayer

@onready var inventory = $InventoryUI

func _ready():
	inventory.close()

func _input(event):
	if event.is_action_pressed("togo_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()
