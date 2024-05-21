extends CharacterBody2D

const SPEED = 200.0

#Input actions
const LEFT = "left"
const RIGHT = "right"
const UP = "up"
const DOWN = "down"

enum {
	WALK,
	ATTACK
}

@onready var body = $Body
@onready var animation_tree = $AnimationTree
var state = WALK
var input_direction = Vector2.ZERO
var attack_direction = Vector2.ZERO

func _ready():
	input_direction = Vector2(0, 1)
	animation_tree["parameters/idle/blend_position"] = input_direction
	animation_tree["parameters/walk/blend_position"] = input_direction
	animation_tree["parameters/attack/blend_position"] = input_direction
	
func _physics_process(delta):
	match state:
		WALK:
			move_state(delta)
		ATTACK:
			attack_state()

func move_state(delta):
	input_direction = Input.get_vector(LEFT, RIGHT, UP, DOWN)
	
	if input_direction == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_walking"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_walking"] = true
		attack_direction = input_direction
		animation_tree["parameters/idle/blend_position"] = input_direction
		animation_tree["parameters/walk/blend_position"] = input_direction
			
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	velocity = input_direction * SPEED
	move_and_slide()
	
func attack_state():
	animation_tree["parameters/attack/blend_position"] = attack_direction
	animation_tree["parameters/conditions/is_attacking"] = true

func set_walk():
	animation_tree["parameters/conditions/is_attacking"] = false
	state = WALK
