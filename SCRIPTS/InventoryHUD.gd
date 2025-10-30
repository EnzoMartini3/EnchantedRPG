extends Control

signal inventoryOpened
signal inventoryClosed
onready var inventory: Inventory = preload("res://Player/playerInventory.tres")
onready var slots: Array = $NinePatchRect/GridContainer.get_children()
onready var audioOpen = $AudioOpen
onready var audioClose = $AudioClose
var isOpen: bool = false

func _ready():
	inventory.connect("inventoryChanged", self, "itemShift")
	audioClose.stream_paused = true
	#itemShift()

#func itemShift():
#	for i in range(min(inventory.items.size(), slots.size())):
#		slots[i].itemShift(inventory.items[i])

func openInventory():
	visible = true
	isOpen = true
	emit_signal("inventoryOpened")
	audioOpen.play()

func closeInventory():
	visible = false
	isOpen = false
	emit_signal("inventoryClosed")
	audioClose.stream_paused = false
	audioClose.play()
