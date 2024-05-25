extends CharacterBody2D

@onready var game = get_node("/root/Game")
@onready var player = get_node("/root/Game/Player")
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 200.0
const PROBABILITY = 5

var healer_item := preload("res://Scenes/healer.tscn")
var target_position
var dead = false
var damage = 10

func _physics_process(delta):
	if dead == false:
		animated_sprite.play("move")
		target_position = (player.position - position).normalized()
		move_and_collide(target_position * 2)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "dead":
		drop_item()
		queue_free()

func _on_damage_area_area_entered(area):
	if area.is_in_group("Sword"):
		die()

func die():
	dead = true
	animated_sprite.play("dead")

func drop_item():
	if (randi() % PROBABILITY) == (PROBABILITY - 1): 
		var healer = healer_item.instantiate()
		healer.position = position
		game.call_deferred("add_child", healer)
	
