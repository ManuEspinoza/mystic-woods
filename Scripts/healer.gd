extends Area2D

@export var HEALTH_UP = 20

func _on_body_entered(body):
	if not body.is_in_group("EnemyAttack"):
		queue_free()
