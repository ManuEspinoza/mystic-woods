extends Node2D
@onready var player = %Player
@onready var animation_tree = %Player/AnimationTree

func _physics_process(delta):
	if animation_tree["parameters/conditions/is_dead"] == true:
		animation_tree["parameters/conditions/is_dead"]
		get_tree().reload_current_scene()
