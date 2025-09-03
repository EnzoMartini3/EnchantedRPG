extends Control

signal inventoryOpened
signal inventoryClosed
var isOpen: bool = false

func openInventory():
	visible = true
	isOpen = true
	emit_signal("inventoryOpened")

func closeInventory():
	visible = false
	isOpen = false
	emit_signal("inventoryClosed")
