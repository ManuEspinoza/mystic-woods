extends CharacterBody2D

const SPEED = 300.0
var last_direction = "move_down"
@onready var animated_sprite = $AnimatedSprite2D

func handle_input(move, flip = false):
	animated_sprite.flip_h = flip
	animated_sprite.play(move)
	last_direction = move
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_direction.x > 0:
		handle_input("move_x")
	elif input_direction.x < 0:
		handle_input("move_x", true)
	elif input_direction.y < 0:
		handle_input("move_up")
	elif input_direction.y > 0:
		handle_input("move_down")
	else:
		if last_direction == "move_up":
			animated_sprite.play("idle_back")
		elif last_direction == "move_down":
			animated_sprite.play("idle")
		else:
			animated_sprite.play("idle_x")
		
	velocity = input_direction * SPEED

func _physics_process(delta):
	get_input()
	move_and_slide()
