class_name Warior extends CharacterBody2D
@export var animated_sprite: AnimatedSprite2D 
@export var health_component: HealthComponent
@onready var player = get_node("/root/Game/Player")
enum {
	WALK,
	ATTACK,
	KNOCKBACK,
	DEAD
}

var healer_item := preload("res://Scenes/healer.tscn")
var target_position
var damage = 10
var state = WALK

func _physics_process(delta):
	match state:
		WALK:
			move_state()
		KNOCKBACK:
			pass
		DEAD:
			animated_sprite.play("dead")

func move_state():
	var target_position
	animated_sprite.play("walk")
	target_position = (player.position - position).normalized()
	move_and_collide(target_position * 2)

func _on_health_component_health_depleted():
	state = DEAD

func _on_hurtbox_component_getting_hit():
	if health_component.current_health > 0:
		state = KNOCKBACK
		animated_sprite.play("knockback")
		target_position = (global_position - player.global_position).normalized()
		move_and_collide(target_position * 2)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "knockback":
		state = WALK
	if animated_sprite.animation == "dead":
		queue_free()
