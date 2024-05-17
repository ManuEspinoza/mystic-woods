extends CharacterBody2D
@onready var character = %Character
@onready var animated_sprite = $AnimatedSprite2D
var target_position

const SPEED = 200.0
var dead = false
func _physics_process(delta):
	if dead == false:
		animated_sprite.play("move")
	target_position = (character.position - position).normalized()
	move_and_collide(target_position * 2)


func _on_hurt_box_area_area_entered(area):
	if area.is_in_group("Sword"):
		dead = true
		animated_sprite.play("dead")
		


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "dead":
		queue_free()
