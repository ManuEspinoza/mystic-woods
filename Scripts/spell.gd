class_name Spell extends Node2D

@export var speed := 100
@export var lifitime :float = 4.5

@onready var sprite_2d = $Sprite2D
@onready var hit_box = $HitBox
@onready var impact_detector = $ImpactDetector
@onready var timer = $Timer

var direction := Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	look_at(position + direction)
	timer.start(lifitime)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += direction * speed * delta

func _on_timer_timeout():
	queue_free()
