class_name Droppable extends Area2D
 
@export var animation_player: AnimationPlayer

func _on_body_entered(body):
	if not body is Enemy:
		animation_player.play("pickup")
