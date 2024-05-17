extends CharacterBody2D

const SPEED = 300.0
const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"
const MOVE_UP = "move_up"
const MOVE_DOWN = "move_down"
const MOVE_SIDE = "move_side"
const IDLE_SIDE = "idle_side"
const IDLE_BACK = "idle_back"
const IDLE = "idle"

var direction = "MOVE_DOWN"
@onready var animated_sprite = $AnimatedSprite2D

func movement_animation(move, flip = false):
	animated_sprite.flip_h = flip
	animated_sprite.play(move)
	direction = move

func idle_animation():
	if direction == MOVE_UP:
		animated_sprite.play(IDLE_BACK)
	elif direction == MOVE_DOWN:
		animated_sprite.play(IDLE)
	else:
		animated_sprite.play(IDLE_SIDE)
	
func player_movement():
	var input_direction = Input.get_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN)
	if input_direction.x > 0:
		movement_animation(MOVE_SIDE)
	elif input_direction.x < 0:
		movement_animation(MOVE_SIDE, true)
	elif input_direction.y < 0:
		movement_animation(MOVE_UP)
	elif input_direction.y > 0:
		movement_animation(MOVE_DOWN)
	else:
		idle_animation()
			
	velocity = input_direction * SPEED

func _physics_process(delta):	
	player_movement()
	move_and_slide()
	
