extends Node2D
@onready var player = %Player
@onready var timer = $Timer
		
func _on_player_health_depleted():
	Engine.time_scale = 0.5
	timer.start()
	
func _on_timer_timeout():
	Engine.time_scale = 1
	get_tree().reload_current_scene()
