extends CharacterBody2D
@onready var player = get_node("/root/Game/Player")
@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 200.0
var dead = false
var damage = 10
var health = 20

func _physics_process(delta):
	var target_position
	if dead == false:
		animated_sprite.play("move")
		target_position = (player.position - position).normalized()
		move_and_collide(target_position * 2)
	else:
		animated_sprite.play("dead")

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "dead":
		queue_free()

func _on_damage_area_area_entered(area):
	if area.is_in_group("Sword"):
		hanlde_damage(area)
	
func hanlde_damage(damager):
	var target_position
	health -= damager.damage
	if health <= 0:
		dead = true
	
		
