extends Area2D

export(String, FILE, "*.tscn") var targetScenePath # Ex: "res://Scenes/GreenMintForest.tscn"
export var spawnPointName = "default_spawn_point" # Nome do Position2D na cena de destino

func _on_TransitionArea_body_entered(body):
	if body is Player:
		# A Main.gd (get_tree().get_root().get_node("Main")) é quem vai gerenciar a troca
		# Você precisa passar o player e a posição de spawn para ela.
		var worldNode = get_tree().get_root().get_node("World")
		
		# Encontra o Position2D de destino na CENA DE DESTINO antes de carregá-la, se possível.
		# OU, o TransitionArea precisa ter os dados do spawn point da CENA ATUAL (para onde ir na PRÓXIMA)
		# Mais simples: o 'spawn_point_name' é o nome do Position2D na target_scene_path
		worldNode.loadMap(targetScenePath, getTargetSpawnPoint(targetScenePath, spawnPointName))

func getTargetSpawnPoint(scenePath: String, spawn_name: String) -> Vector2:
	# Esta é uma função auxiliar para obter a posição do spawn point na cena de destino
	# sem instanciá-la completamente. É um pouco mais avançado, mas ideal para evitar bugs.
	# Alternativamente, você pode definir a posição diretamente como 'export var' no TransitionArea,
	# ou simplesmente carregar a cena e depois procurar o spawn point como fizemos antes.
	
	# A maneira mais simples e robusta para seu nível atual é o TransitionArea exportar a Posição2D
	# exata que o Player deve ter na PRÓXIMA CENA.
	# export var player_spawn_position_in_next_scene = Vector2(100, 100)
	# E então passar isso para main_node.load_map_scene(target_scene_path, player_spawn_position_in_next_scene)
	
	# Se você quiser o Position2D, precisa carregar a cena temporariamente para encontrá-lo
	var tempScene = load(scenePath).instance()
	var spawnPoint = tempScene.find_node(spawn_name, true, false)
	var pos = Vector2.ZERO
	if spawnPoint:
		pos = spawnPoint.position # Use .position pois é relativa à cena que ela está
	tempScene.queue_free() # Liberar a cena temporária
	return pos
