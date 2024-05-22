extends Node2D
@onready var player = %Player

func _physics_process(delta):
	if player.health <= 0:
		get_tree().reload_current_scene()
