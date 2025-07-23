extends Node2D

onready var player = $Player
onready var camera = $PlayerCamera
onready var currentMap = $CurrentMap

var currentMapInstance = null

func _ready():
	loadMap("res://World/Towns/Tinymint/Tinymint Town.tscn",Vector2(50, 50))

func loadMap(pathToScene: String, playerSpawnPos: Vector2):
	if currentMapInstance:
		currentMapInstance.queue_free()
		currentMapInstance = null
	
	currentMapInstance = load(pathToScene).instance() # Cria a nova instância do mapa
	currentMap.add_child(currentMapInstance)
	
	var mapYsort = currentMapInstance.find_node("YSort", true, false)
	player.get_parent().remove_child(player)
	mapYsort.add_child(player) # coloca o Player como filho do Ysort local do mapa
	
	var playerRemoteTransform = player.find_node("RemoteTransform2D", true, false)
	playerRemoteTransform.remote_path = "/root/World/PlayerCamera"
	player.global_position = playerSpawnPos


