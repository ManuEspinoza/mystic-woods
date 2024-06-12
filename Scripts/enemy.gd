class_name Enemy extends CharacterBody2D
@export var animation_tree: AnimationTree
@export var health_component: HealthComponent
@export var body: CollisionShape2D
@export var body_damage: int = 0
@export var attack_range: AttackRangeComponent
@export var navigation_agent: NavigationAgent2D
@export var navigation_timer: Timer

@onready var player = get_node("/root/Game/Player")
@onready var game = get_node("/root/Game")

enum {
	WALK,
	ATTACK,
	KNOCKBACK,
	DEAD
}
const HEART_PROBABILITY = 7
const SHIELD_PROBABILITY = 10
const healer_item := preload("res://Scenes/healer.tscn")
const shield_item := preload("res://Scenes/droppable_shield.tscn")
var target_position
var damage = 10
var state = WALK
var is_dead = false
	
func _physics_process(delta):
	if is_dead == true:
		return
	get_facing_direction()
	is_player_in_range()
		
	match state:
		WALK:
			move_state()
		KNOCKBACK:
			knockback_state()
		ATTACK:
			attack_state()
		DEAD:
			dead_state()

func is_player_in_range():
	if attack_range == null || animation_tree["parameters/conditions/is_attacking"]:
		return
	var bodies = attack_range.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			state = ATTACK

func get_facing_direction():
	var direction_to = position.direction_to(player.position)
	var facing_direction = Vector2.ZERO
	if direction_to.x > 0:
		facing_direction.x = 1
	else:
		facing_direction.x = -1
	blend_position(facing_direction)
	
func blend_position(facing_direction):
	if animation_tree["parameters/conditions/is_attacking"]:
		return 
	animation_tree["parameters/attack/blend_position"] = facing_direction
	animation_tree["parameters/walk/blend_position"] = facing_direction
	animation_tree["parameters/knockback/blend_position"] = facing_direction	
	
func dead_state():
	is_dead = true
	body.disabled = true
	set_animtion_tree_condition("parameters/conditions/is_dead")	
	
func move_state():
	body.disabled = false
	set_animtion_tree_condition("parameters/conditions/is_walking")
	var dir = to_local(navigation_agent.get_next_path_position()).normalized()
	velocity = dir * 100
	move_and_slide()
	
func knockback_state():
	body.disabled = false
	set_animtion_tree_condition("parameters/conditions/is_hit")
	target_position = (global_position - player.global_position).normalized()
	move_and_collide(target_position * 2)
	
func attack_state():
	body.disabled = false
	set_animtion_tree_condition("parameters/conditions/is_attacking")

func _on_health_component_health_depleted():
	state = DEAD

func _on_hurtbox_component_getting_hit():
	if health_component.current_health > 0:
		state = KNOCKBACK

func _on_animation_tree_animation_finished(anim_name):
	if anim_name != "dead":
		state = WALK
	else:
		drop_item()
		queue_free()

func set_animtion_tree_condition(condition):
	animation_tree["parameters/conditions/is_hit"] = false
	animation_tree["parameters/conditions/is_attacking"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/is_dead"] = false
	animation_tree[condition] = true
	
func drop_item():
	var dropped = get_probability(HEART_PROBABILITY, healer_item)
	if not dropped:
		get_probability(SHIELD_PROBABILITY, shield_item)
	
		
func get_probability(PROBABILITY, dropable_item):
	randomize()
	if(randi() % PROBABILITY) == (PROBABILITY - 1):
		var dropable = dropable_item.instantiate()
		dropable.position = position
		game.call_deferred("add_child", dropable)
		return true
	
	return false

func find_path():
	navigation_agent.target_position = player.global_position
 
func _on_navigation_timer_timeout():
	find_path()
	
