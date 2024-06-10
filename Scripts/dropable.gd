extends Area2D

@export var HEALTH_UP = 20
@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	if not body is Enemy:
		animation_player.play("pickup")
