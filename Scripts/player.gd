class_name Player extends CharacterBody2D

signal health_depleted
@export var steps: GPUParticles2D
@export var final_attack_cooldown_timer: Timer
@export var cooldown: int
@onready var health_bar = $health_bar
@onready var animation_tree = $AnimationTree
@onready var body_area = $BodyArea
@onready var damage_timer = $"Damage Timer"
@onready var sprite = $Body
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
const FINAL_ATTACK_SCENE = preload("res://Scenes/final_attack.tscn")

const SPEED = 200.0

#Input actions
const LEFT = "left"
const RIGHT = "right"
const UP = "up"
const DOWN = "down"
const FINAL = "final"

const FLICKERS_TIME = 0.2
const MAX_HEALTH = 100
const INVENCIBILITY_TIME = 1

enum {
	WALK,
	ATTACK,
	FINAL_ATTACK,
	DEAD
}

var state = WALK
var input_direction = Vector2.ZERO
var attack_direction = Vector2.ZERO
var health = 100

func _ready():
	input_direction = Vector2(0, 1)
	health_bar.visible = false
	health_bar.value = health
	update_blend_directions()
	animation_tree["parameters/attack/blend_position"] = input_direction
	final_attack_cooldown_timer.start(cooldown)
	
func _physics_process(delta):
	handle_enemy_damage()
	match state:
		WALK:
			move_state(delta)
		ATTACK:
			attack_state()
		FINAL_ATTACK:
			final_state()
		_: 
			pass

func _on_body_area_body_entered(body):
	handle_enemy_damage()
		
func _on_body_area_area_entered(area):
	if area.is_in_group("Droppable"):
		handle_droppable(area)
	elif area.is_in_group("Attack"):
		handle_attack_damage(area)

func handle_attack_damage(attack_area):
	handle_damage_dealed(attack_area.damage)
	
func handle_enemy_damage():
	for body in body_area.get_overlapping_bodies():
		if body is Enemy:
			handle_damage_dealed(body.damage)
		
func handle_damage_dealed(damage):
	if not damage_timer.is_stopped():
		return
	var final_health = health
	final_health -= damage;
	health_bar.value = final_health
	health = final_health
	
	if final_health <= 0:
		state = DEAD
		set_animation_conditions("parameters/conditions/is_dead")
		health_depleted.emit()
		
	if final_health < MAX_HEALTH:
		health_bar.visible = true
	damage_timer.start(INVENCIBILITY_TIME)
	flick_sprite()
	
func flick_sprite():
	audio_stream_player_2d.play()
	sprite.modulate = Color.RED
	await get_tree().create_timer(FLICKERS_TIME).timeout
	sprite.modulate = Color.WHITE

func handle_droppable(droppable):
	if droppable.effect:
		droppable.effect(self)

func move_state(delta):
	input_direction = Input.get_vector(LEFT, RIGHT, UP, DOWN)
	steps.process_material.direction = Vector3(input_direction.x, input_direction.y, 0) * -1
	if input_direction == Vector2.ZERO:
		set_animation_conditions("parameters/conditions/idle")
	else:
		attack_direction = input_direction
		set_animation_conditions("parameters/conditions/is_walking")
		update_blend_directions()
			
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	velocity = input_direction * SPEED
	move_and_slide()
	
func set_animation_conditions(condition):
	animation_tree["parameters/conditions/idle"] = false
	animation_tree["parameters/conditions/is_final_attacking"] = false
	animation_tree["parameters/conditions/is_walking"] = false
	animation_tree["parameters/conditions/idle"] = false
	animation_tree["parameters/conditions/is_attacking"] = false
	animation_tree[condition] = true

func update_blend_directions():
	animation_tree["parameters/idle/blend_position"] = input_direction
	animation_tree["parameters/walk/blend_position"] = input_direction

func attack_state():
	animation_tree["parameters/attack/blend_position"] = attack_direction
	set_animation_conditions("parameters/conditions/is_attacking")

func final_state():
	set_animation_conditions("parameters/conditions/is_final_attacking")

func _on_health_bar_value_changed(value):
	if value == health_bar.max_value:
		health_bar.visible = false
	else:
		health_bar.visible = true
		
func _input(event):
	if event.is_action_pressed(FINAL) and final_attack_cooldown_timer.is_stopped():
		state = FINAL_ATTACK
		var final_attack_instance = FINAL_ATTACK_SCENE.instantiate()
		final_attack_instance.position = position
		get_parent().call_deferred("add_child", final_attack_instance)
		final_attack_cooldown_timer.start(cooldown)


func _on_animation_tree_animation_finished(anim_name):
	state = WALK
