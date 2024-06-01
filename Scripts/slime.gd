class_name Slime extends Enemy
var direction := Vector2.ZERO

func attack():
	direction = global_position.direction_to(player.global_position)
	var target_position = (player.position - position).normalized()
	move_and_collide(target_position * direction)
