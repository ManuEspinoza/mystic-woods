extends Node2D
@export var top_left := Vector2(1,1) # your co-ords here
@export var bot_right := Vector2(500,410) # your co-ords here
@onready var timer = $Timer
var all_portals_destroyed := false
		
func _on_player_health_depleted():
	Engine.time_scale = 0.5
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_spawner_all_portals_destroyed():
	all_portals_destroyed = true
	count_enemies()

func _on_child_exiting_tree(node):
	count_enemies()

func count_enemies():
	var count = 0
	for i in get_children():
		if i is Enemy:
			count += 1
	if count < 1 and all_portals_destroyed:
		you_win()

func you_win():
	print("I win?")
