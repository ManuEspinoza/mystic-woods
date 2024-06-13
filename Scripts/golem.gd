class_name Golem extends CharacterBody2D

@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@export var health_component: HealthComponent
@export var body: CollisionShape2D
@export var body_damage: int = 0
@export var attack_range: AttackRangeComponent
@export var chase_range: AttackRangeComponent
@onready var player = get_node("/root/Game/Player")
@onready var game = get_node("/root/Game")

enum {
	IDLE,
	WALK,
	ATTACK,
	DEAD
}
const HEART_PROBABILITY = 7
const SHIELD_PROBABILITY = 10
const SPEED = 75
const healer_item := preload("res://Scenes/healer.tscn")
const shield_item := preload("res://Scenes/droppable_shield.tscn")
var target_position
var state = IDLE
var is_dead = false
var inicial_position = Vector2.ZERO
var movement_range = 50

func _ready():
	if position.x > 0:
		position.x = position.x - 35
	else:
		position.x = position.x + 35
		
	inicial_position = position
	
func _physics_process(delta):
	if is_dead == true:
		return
	get_facing_direction()
	is_player_in_range()
		
	match state:
		WALK:
			move_state()
		IDLE:
			idle_state()
		ATTACK:
			attack_state()
		DEAD:
			dead_state()

func is_player_in_range():
	if attack_range == null || animation_tree["parameters/conditions/is_attacking"]:
		return
	if not action_in_range(attack_range, ATTACK):
		action_in_range(chase_range, WALK)

func action_in_range(range, action):
	var bodies = range.get_overlapping_bodies()
	for overlapping_body in bodies:
		if overlapping_body is Player:
			state = action
			return true
	return false

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
	animation_tree["parameters/idle/blend_position"] = facing_direction	
	
func dead_state():
	is_dead = true
	body.disabled = true
	if not animation_tree["parameters/conditions/is_dead"]:
		set_animtion_tree_condition("parameters/conditions/is_dead")	
	
func move_state():
	body.disabled = false
	if not animation_tree["parameters/conditions/is_walking"]:
		set_animtion_tree_condition("parameters/conditions/is_walking")
	if out_of_movement_range():
		go_to_inicial_position()
	else:
		go_torward_player()
		
func go_torward_player():
	var dir = position.direction_to(player.position)
	velocity = dir * SPEED
	move_and_slide()
	
func go_to_inicial_position():
	var dir = position.direction_to(inicial_position)
	velocity = dir * SPEED
	move_and_slide()
	state = IDLE
	
func out_of_movement_range():
	var distance = inicial_position - position
	
	if distance.length() >= movement_range:
		return true
	return false

func idle_state():
	body.disabled = false
	if not animation_tree["parameters/conditions/is_idle"]:
		set_animtion_tree_condition("parameters/conditions/is_idle")
	
func attack_state():
	body.disabled = false
	if not animation_tree["parameters/conditions/is_attacking"]:
		set_animtion_tree_condition("parameters/conditions/is_attacking")

func _on_health_component_health_depleted():
	state = DEAD

func _on_animation_tree_animation_finished(anim_name):
	if anim_name != "dead":
		state = WALK
	else:
		drop_item()
		queue_free()

func set_animtion_tree_condition(condition):
	animation_tree["parameters/conditions/is_idle"] = false
	animation_tree["parameters/conditions/is_attacking"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/is_dead"] = false
	animation_tree[condition] = true
	
func drop_item():
	var dropable = healer_item.instantiate()
	dropable.position = position
	game.call_deferred("add_child", dropable)
	
func _on_hurtbox_component_getting_hit():
	if not is_dead:
		animation_player.play("hit")
