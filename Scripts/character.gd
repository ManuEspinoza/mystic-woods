extends CharacterBody2D

const SPEED = 200.0

#Input actions
const LEFT = "left"
const RIGHT = "right"
const UP = "up"
const DOWN = "down"

#Animations names
const MOVE_DOWN = "move_down"
const MOVE_UP = "move_up"
const MOVE_SIDE = "move_side"
const IDLE_SIDE = "idle_side"
const IDLE_BACK = "idle_back"
const IDLE = "idle"

var direction = DOWN
var is_attacking = false
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):	
	attack()
	player_movement()
	move_and_slide()

func movement_animation(animation, looking_at, flip = false):
	animated_sprite.flip_h = flip
	animated_sprite.play(animation)
	direction = looking_at

func idle_animation():
	if direction == UP:
		animated_sprite.play(IDLE_BACK)
	elif direction == DOWN:
		animated_sprite.play(IDLE)
	else:
		animated_sprite.play(IDLE_SIDE)
	
func player_movement():
	var input_direction = Input.get_vector(LEFT, RIGHT, UP, DOWN)
	if input_direction.x > 0 && is_attacking == false:
		movement_animation(MOVE_SIDE, RIGHT)
	elif input_direction.x < 0 && is_attacking == false:
		movement_animation(MOVE_SIDE, LEFT, true)
	elif input_direction.y < 0 && is_attacking == false:
		movement_animation(MOVE_UP, UP)
	elif input_direction.y > 0 && is_attacking == false:
		movement_animation(MOVE_DOWN, DOWN)
	else:
		if is_attacking == false:
			idle_animation()
			
	velocity = input_direction * SPEED

func attack():
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		
		if direction == DOWN:
			animated_sprite.play("attack_down")
		elif direction == UP:
			animated_sprite.play("attack_up")
		elif direction == RIGHT:
			animated_sprite.flip_h = false
			animated_sprite.play("attack_side")
		elif direction == LEFT:
			animated_sprite.flip_h = true
			animated_sprite.play("attack_side")
			
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attack_down" or animated_sprite.animation == "attack_up" or animated_sprite.animation == "attack_side":
		is_attacking = false
