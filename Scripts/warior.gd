class_name Warior extends CharacterBody2D
@export var animation_tree: AnimationTree
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
	get_facing_direction()
	match state:
		WALK:
			move_state()
		KNOCKBACK:
			knockback_state()
		ATTACK:
			attack_state()
		DEAD:
			dead_state()

func get_facing_direction():
	var direction_to = position.direction_to(player.position)
	var facing_direction = Vector2.ZERO
	if direction_to.x > 0:
		facing_direction.x = 1
	else:
		facing_direction.x = -1
	animation_tree["parameters/attack/blend_position"] = facing_direction
	animation_tree["parameters/walk/blend_position"] = facing_direction
	animation_tree["parameters/knockback/blend_position"] = facing_direction
	
func dead_state():
	set_animtion_tree_condition("parameters/conditions/is_dead")
	
func move_state():
	set_animtion_tree_condition("parameters/conditions/is_walking")
	target_position = (player.position - position).normalized()
	move_and_collide(target_position * 2)
	
func knockback_state():
	set_animtion_tree_condition("parameters/conditions/is_hit")
	target_position = (global_position - player.global_position).normalized()
	move_and_collide(target_position * 2)
	
func attack_state():
	set_animtion_tree_condition("parameters/conditions/is_attacking")

func _on_health_component_health_depleted():
	state = DEAD

func _on_hurtbox_component_getting_hit():
	if health_component.current_health > 0:
		state = KNOCKBACK

func _on_attack_range_component_on_range():
	state = ATTACK

func _on_animation_tree_animation_finished(anim_name):
	if anim_name != "dead":
		state = WALK
	else:
		queue_free()

func set_animtion_tree_condition(condition):
	animation_tree["parameters/conditions/is_hit"] = false
	animation_tree["parameters/conditions/is_attacking"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/is_dead"] = false
	animation_tree[condition] = true
