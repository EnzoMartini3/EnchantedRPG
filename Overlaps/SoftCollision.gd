extends Area2D

func getPlayer():
	var areas = get_overlapping_areas()
	for area in areas:
		var root = area.get_parent()
		while root and not root.is_in_group("Player"):
			root = root.get_parent()
		if root and root.is_in_group("Player"):
			return root
	return null

func isColliding():
	var areas = get_overlapping_areas() #retorna um array
	return areas.size() > 0 #se o array existir, significa uma colisão
	
func getPushVector():
	var areas = get_overlapping_areas()
	var pushVector = Vector2.ZERO
	if isColliding():
		var area = areas[0] #pega a primeira área causando colisão
		pushVector = area.global_position.direction_to(global_position)
		#um vetor que vai da posição dele até a sua posição
		pushVector = pushVector.normalized()
	return pushVector
