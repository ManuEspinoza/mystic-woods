extends CharacterBody2D
@onready var player = %Player
@onready var animated_sprite = $AnimatedSprite2D
var target_position

const SPEED = 200.0
var dead = false
func _physics_process(delta):
	if dead == false:
		animated_sprite.play("move")
	target_position = (player.position - position).normalized()
	move_and_collide(target_position * 2)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "dead":
		queue_free()

func _on_hurting_area_2d_area_entered(area):
	if area.is_in_group("Sword"):
		dead = true
		animated_sprite.play("dead")
