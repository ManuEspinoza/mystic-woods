class_name HealthComponent extends Node
#Signals
signal health_depleted

#Properties
@export var max_health: int
var current_health: int

func _ready():
	current_health = max_health
#Functions
func take_damage(damage):
	print("before", current_health)
	current_health -= damage
	print("after", current_health)
	if current_health <= 0:
		health_depleted.emit()
	
