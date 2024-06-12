extends Droppable
@export var HEALTH_UP = 20


func effect(body: Player):
	if body.health < body.MAX_HEALTH:
		var health_difference = abs(body.MAX_HEALTH - body.health)
		if health_difference < HEALTH_UP:
			body.health += health_difference 
		else:
			body.health += HEALTH_UP
	
	body.heathbar.value = body.health
