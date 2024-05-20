extends CharacterBody2D

const SPEED = 200.0

#Input actions
const LEFT = "left"
const RIGHT = "right"
const UP = "up"
const DOWN = "down"

@onready var animation_tree = $AnimationTree
var input_direction = Vector2.ZERO

func _physics_process(delta):
	input_direction = Input.get_vector(LEFT, RIGHT, UP, DOWN)
	
	if input_direction == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		update_blend_position()
	velocity = input_direction * SPEED
	move_and_slide()

func update_blend_position():
	animation_tree["parameters/idle/blend_position"] = input_direction
	animation_tree["parameters/attack/blend_position"] = input_direction
	animation_tree["parameters/walk/blend_position"] = input_direction
	
