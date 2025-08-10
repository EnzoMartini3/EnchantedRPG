extends Node2D

onready var player = $Player
onready var camera = $PlayerCamera
onready var currentMapNode = $CurrentMap
var currentMapInstance = null
var nextWarp = ""
const sceneTinymintTown = preload("res://World/Towns/Tinymint/Tinymint Town.tscn")
const sceneMintsilkPath = preload("res://World/Pathways/Mintsilk Path/Mintsilk Path.tscn")

func _ready():
	loadMap(sceneTinymintTown, Vector2(50, 50))
	var playerRemoteTransform = player.find_node("RemoteTransform2D", true, false)
	playerRemoteTransform.remote_path = "/root/World/PlayerCamera"

func loadMap(sceneResource: PackedScene, playerSpawnPos: Vector2):
	if player.get_parent() != self: # Se o player NÃO é filho direto de World (ou seja, ele está no YSort do mapa anterior)
		player.get_parent().remove_child(player)
		add_child(player)

	if currentMapInstance:
		currentMapInstance.queue_free()
		currentMapInstance = null
	
	var newMapScene = sceneResource.instance() # Cria a nova instância do mapa
	currentMapNode.add_child(newMapScene)
	currentMapInstance = newMapScene
	
	var mapYsort = newMapScene.find_node("YSort", true, false)
	player.get_parent().remove_child(player) # Remove da cena World
	mapYsort.add_child(player) 
	
	var finalPlayerPosition = playerSpawnPos # Começa com a posição padrão ou inicial
	if nextWarp != "": # Se uma warp de destino foi especificada
		var targetWarpNode = newMapScene.find_node(nextWarp, true, false)
		finalPlayerPosition = targetWarpNode.global_position
		nextWarp = ""
	player.global_position = finalPlayerPosition
	adjustMapLimits(currentMapInstance)

func goToScene(sceneTag: String, targetTag: String):
	var loadScene: PackedScene = null
	match sceneTag:
		"Tinymint Town":
				loadScene = sceneTinymintTown
		"Mintsilk Path":
				loadScene = sceneMintsilkPath
	if loadScene != null:
		nextWarp = targetTag # Armazena a tag do warp de destino
		call_deferred("loadMap", loadScene, Vector2.ZERO)

func adjustMapLimits(mapScene: Node):
	var mapLimitsContainer = mapScene.find_node("MapLimits", true, false)

	if mapLimitsContainer:
		var topLeft = mapLimitsContainer.find_node("TopLeft", true, false)
		var bottomRight = mapLimitsContainer.find_node("BottomRight", true, false)
		
		if topLeft and bottomRight:
			camera.limit_top = topLeft.global_position.y
			camera.limit_bottom = bottomRight.global_position.y
			camera.limit_left = topLeft.global_position.x
			camera.limit_right = bottomRight.global_position.x 
