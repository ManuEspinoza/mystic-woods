extends Droppable
const SHIELD = preload("res://Scenes/shield.tscn")

func effect(player: Player):
	stop_another_shield(player)
	var shield = SHIELD.instantiate()
	player.add_child(shield)
	
func stop_another_shield(player: Player):
	for node in player.get_children():
		if node is Shield:
			node.queue_free()
