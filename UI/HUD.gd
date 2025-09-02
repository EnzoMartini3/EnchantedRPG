extends CanvasLayer

onready var crystalBar = $CrystalBar

func updateFuel(value: float):
	crystalBar.value = value
