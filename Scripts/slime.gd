extends CharacterBody2D
@onready var character = %Character
var target_position

const SPEED = 200.0

func _physics_process(delta):
	target_position = (character.position - position).normalized()
	move_and_collide(target_position * 2)
