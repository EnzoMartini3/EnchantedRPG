extends CanvasLayer

onready var crystalBar = $CrystalBar
onready var inventory = $InventoryUI

func _ready():
	inventory.closeInventory()

func _input(_event):
	if Input.is_action_just_pressed("inventory"):
		if inventory.isOpen:
			inventory.closeInventory()
		else:
			inventory.openInventory()

func updateFuel(value: float):
	crystalBar.value = value
