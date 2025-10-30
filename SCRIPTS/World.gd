extends Node2D

onready var player = $Player
onready var camera = $PlayerCamera
onready var currentMapNode = $CurrentMap

var currentMapInstance = null
var nextWarp = ""
var returnScenePath = ""
var returnPosition = Vector2.ZERO # Quando o jogador usa a Dreambox, o jogo salva a Cena e a Posição que ele deve retornar
var dreamboxHolder: Node = null

const sceneDreamTent = preload("res://Buildings/Dream Tent/DreamHouse.tscn")
const sceneTinymintTown = preload("res://World/Towns/Tinymint/Tinymint Town.tscn")
const sceneMintsilkPath = preload("res://World/Open Areas/Mintsilk Path/Mintsilk Path.tscn")


func _ready():
	randomize()
	loadMap(sceneTinymintTown, Vector2(50, 50))
	var playerRemoteTransform = player.find_node("RemoteTransform2D", true, false)
	playerRemoteTransform.remote_path = "/root/World/PlayerCamera"
	player.connectToHUD()


func loadMap(sceneResource: PackedScene, playerSpawnPos: Vector2):
	if player.get_parent() != self: # Se o player NÃO é filho direto de World (ou seja, ele está no YSort do mapa anterior)
		player.get_parent().remove_child(player)
		add_child(player)
	
	if currentMapInstance:
		currentMapInstance.queue_free()
		currentMapInstance = null
	
	var newMapScene = sceneResource.instance() # nova instância do mapa pra buscar ysort e etc
	currentMapNode.add_child(newMapScene)
	currentMapInstance = newMapScene
	
	var mapYsort = newMapScene.find_node("YSort", true, false)
	player.get_parent().remove_child(player) # Remove do World
	mapYsort.add_child(player) # SE DER ERRO AQUI PODE SER PQ FALTA UM YSORT NO MAPA
	
	var finalPlayerPosition = playerSpawnPos # Começa com a posição padrão ou inicial
	if nextWarp != "": # Warp de destino
		var targetWarpNode = newMapScene.find_node(nextWarp, true, false)
		finalPlayerPosition = targetWarpNode.global_position
		nextWarp = ""
	player.global_position = finalPlayerPosition
	adjustMapLimits(currentMapInstance)


func goToScene(sceneTag: String, targetTag: String):
	returnScenePath = currentMapInstance.filename
	returnPosition = player.global_position
	var loadScene: PackedScene = null
	match sceneTag:
		"Dream Tent":
			loadScene = sceneDreamTent
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


func dreamboxTrigger(dreambox: Area2D, targetScene: String, entryPoint: String):
	dreambox.set_deferred("monitoring", false) 
	call_deferred("dreamboxDelayedSpecs", dreambox, targetScene, entryPoint)


func dreamboxDelayedSpecs(dreambox: Area2D, targetScene: String, entryPoint: String):
	dreambox.get_parent().remove_child(dreambox)
	add_child(dreambox) #para que ela nao desapareça totalmente
	dreamboxHolder = dreambox
	goToScene(targetScene, entryPoint)


func dungeonWarpBack():
	var sceneResource = load(returnScenePath)
	call_deferred("loadMap", sceneResource, returnPosition)
	returnScenePath = ""
	returnPosition = Vector2.ZERO


func _on_InventoryUI_inventoryOpened():
	get_tree().paused = true


func _on_InventoryUI_inventoryClosed():
	get_tree().paused = false
