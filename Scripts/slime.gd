extends CharacterBody2D
@onready var player = get_node("/root/Game/Player")
@onready var animated_sprite = $AnimatedSprite2D

enum {
	WALK,
	DEAD
}
const SPEED = 200.0
var damage = 10
var health = 20
var state = WALK
var hit = false

func _physics_process(delta):
	match state:
		WALK:
			move_state()
		DEAD:
			animated_sprite.play("dead")
			
func move_state():
	if health <= 0:
		state = DEAD
		pass
	var target_position
	if !hit:
		animated_sprite.play("move")
		target_position = (player.position - position).normalized()
		move_and_collide(target_position * 2)
	else:
		#knockback
		target_position = (global_position - player.global_position).normalized()
		move_and_collide(target_position)

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "dead":
		queue_free()
	if animated_sprite.animation == "recoil":
		hit = false

func _on_damage_area_area_entered(area):
	if area.is_in_group("Sword") && state != DEAD:
		hit = true
		hanlde_damage(area)
	
func hanlde_damage(damager):
	animated_sprite.play("recoil")
	health -= damager.damage
	if health <= 0:
		state = DEAD
		
