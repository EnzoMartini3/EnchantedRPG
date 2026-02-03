extends Node2D

onready var player = $Player
onready var camera = $PlayerCamera
onready var currentMapNode = $CurrentMap

var returnScenePath: String = ""
var returnSpawnName: String = ""

func _ready():
	randomize()
	loadMap(preload("res://World/Towns/Tinymint/Tinymint Town.tscn"), "Start") # MAPA INICIAL
	var playerRemoteTransform = player.find_node("RemoteTransform2D", true, false)
	playerRemoteTransform.remote_path = "/root/World/PlayerCamera"
	player.connectToHUD()


# RESUMO DE COMO FUNCIONAM OS MAPAS + WARPS: Quando entramos em um mapa, o jogo prepara todas as warps antes mesmo do jogador entrar nelas, configurando elas à um sinal. Quando são usadas, as warps emitem o sinal e a função loadMap é carregada a partir disso.
func loadMap(sceneResource: PackedScene, spawnName):
	for loopMap in currentMapNode.get_children():          #limpando o mapa atual: primeiro tiramos o mapa da árvore e depois o destruímos da memória
		currentMapNode.remove_child(loopMap)
		loopMap.queue_free()                               #usamos essas 2 linhas separadamente pra facilitar a remoção da memória do jogo. Caso contrário, o jogo crasha.
	var newMap = sceneResource.instance()                  #instanciamos o mapa a ser carregado
	currentMapNode.add_child(newMap)                       #adicionamos o mapa novo
			
	var allWarps = newMap.find_node("Warps", true, false)  #buscamos todas as warps recursivamente
	for warp in allWarps.get_children():
		if warp.has_signal("dungeonEntered"):
			warp.connect("dungeonEntered", self, "activateDungeonWarp")
		elif warp.has_signal("returnRequested"):
			warp.connect("returnRequested", self, "dungeonReturn")
		elif warp.has_signal("warpEntered"):
			warp.connect("warpEntered", self, "activateWarp")   #conectamos as warps as funcoes correspondentes
			
	var targetPos = Vector2.ZERO    #posicao vazia
	var spawns = newMap.find_node("Spawnpoints", true, false)   #damos uma olhada em todos os spawnpoints do mapa
	for spawn in spawns.get_children():
		if spawn.name == spawnName:                        #para cada resultado, vemos se é esse que procuramos(ou seja, se é a mesma inserida no argumento dessa funcao)
			targetPos = spawn.global_position
			break
	player.global_position = targetPos                     #player é direcionado para a posição encontrada, ou seja, spawna no spawnpoint
			
	var mapYsort = newMap.find_node("YSort", true, false)
	player.get_parent().remove_child(player)               #removemos o player temporariamente
	mapYsort.add_child(player)                             #e transferimos ele para o ysort do novo mapa
	adjustMapLimits(newMap)


func activateWarp(targetScene, targetSpawn):
	#animacao fade in/out
	call_deferred("loadMap", targetScene, targetSpawn)

func activateDungeonWarp(targetScene, targetSpawn, returnName):
	if currentMapNode.get_child_count() > 0:
		returnScenePath = currentMapNode.get_child(0).filename
	returnSpawnName = returnName
	call_deferred("loadMap", targetScene, targetSpawn)

func dungeonReturn():
	var sceneToGo = load(returnScenePath)
	call_deferred("loadMap", sceneToGo, returnSpawnName)
	returnScenePath = ""
	returnSpawnName = ""


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


func _on_InventoryHUD_inventoryOpened():
	get_tree().paused = true

func _on_InventoryHUD_inventoryClosed():
	get_tree().paused = false
