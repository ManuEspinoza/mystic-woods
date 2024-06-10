extends Droppable
const SHIELD = preload("res://Scenes/shield.tscn")

func effect(body: Player):
	var shield = SHIELD.instantiate()
	body.add_child(shield)
