class_name Player extends CharacterBody2D

signal health_depleted

@onready var heathbar = $heathbar
@onready var animation_tree = $AnimationTree
@onready var body_area = $BodyArea
@onready var damage_timer = $"Damage Timer"
@onready var sprite = $Body
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

const SPEED = 200.0

#Input actions
const LEFT = "left"
const RIGHT = "right"
const UP = "up"
const DOWN = "down"

const FLICKERS_TIME = 0.2
const MAX_HEALTH = 100

enum {
	WALK,
	ATTACK,
	DEAD
}

var state = WALK
var input_direction = Vector2.ZERO
var attack_direction = Vector2.ZERO
var health = 100

func _ready():
	input_direction = Vector2(0, 1)
	heathbar.visible = false
	heathbar.value = health
	update_blend_directions()
	animation_tree["parameters/attack/blend_position"] = input_direction
	
func _physics_process(delta):
	handle_enemy_damage()
	match state:
		WALK:
			move_state(delta)
		ATTACK:
			attack_state()

func _on_body_area_body_entered(body):
	handle_enemy_damage()
		
func _on_body_area_area_entered(area):
	if area.is_in_group("Healer"):
		handle_health_up(area)
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
	heathbar.value = final_health
	health = final_health
	
	if final_health <= 0:
		state = DEAD
		animation_tree["parameters/conditions/is_dead"] = true
		health_depleted.emit()
		
	if final_health < MAX_HEALTH:
		heathbar.visible = true
	damage_timer.start()
	flick_sprite()
	
func flick_sprite():
	audio_stream_player_2d.play()
	sprite.modulate = Color.RED
	await get_tree().create_timer(FLICKERS_TIME).timeout
	sprite.modulate = Color.WHITE

func handle_health_up(healer):
	if health < MAX_HEALTH:
		var health_difference = abs(MAX_HEALTH - health)
		if health_difference < healer.HEALTH_UP:
			health += health_difference 
		else:
			health += healer.HEALTH_UP
	
	heathbar.value = health
	
	if health == MAX_HEALTH:
		heathbar.visible = false

func move_state(delta):
	input_direction = Input.get_vector(LEFT, RIGHT, UP, DOWN)
	
	if input_direction == Vector2.ZERO:
		set_walk_conditions(false)
	else:
		attack_direction = input_direction
		set_walk_conditions(true)
		update_blend_directions()
			
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	velocity = input_direction * SPEED
	move_and_slide()
	
func set_walk_conditions(walk):
	animation_tree["parameters/conditions/idle"] = not walk
	animation_tree["parameters/conditions/is_walking"] = walk

func update_blend_directions():
	animation_tree["parameters/idle/blend_position"] = input_direction
	animation_tree["parameters/walk/blend_position"] = input_direction

func attack_state():
	animation_tree["parameters/attack/blend_position"] = attack_direction
	animation_tree["parameters/conditions/is_attacking"] = true

func set_walk():
	animation_tree["parameters/conditions/is_attacking"] = false
	state = WALK
