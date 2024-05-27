class_name AttackRangeComponent extends Area2D
@export var collision_shape: CollisionShape2D
signal on_range

func _on_body_entered(body):
	if body.is_in_group("Player"):
		on_range.emit()
