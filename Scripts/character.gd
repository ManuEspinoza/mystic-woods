extends CharacterBody2D

const SPEED = 300.0
@onready var animated_sprite = $AnimatedSprite2D

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction.x > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("move_x")
	elif input_direction.x < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("move_x")
	elif input_direction.y < 0:
		animated_sprite.play("move_up")
	elif input_direction.y > 0:
		animated_sprite.play("move_down")
	else:
		animated_sprite.play("idle")
		
	velocity = input_direction * SPEED

func _physics_process(delta):
	get_input()
	move_and_slide()
