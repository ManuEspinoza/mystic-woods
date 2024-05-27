extends Node2D
const slime_scene := preload("res://Scenes/slime.tscn")
@onready var timer = $Timer
@onready var game = get_node("/root/Game")
var spawn_points := []
# Called when the node enters the scene tree for the first time.
func _ready():
	populate_spawn_points()
	timer.start()
	spawn()
	
func populate_spawn_points():
	for i in get_children():
		if i is Marker2D:
			spawn_points.append(i)
			
func spawn():
	#pick random spawner
	var spwan = spawn_points[randi() % spawn_points.size()]
	var enemy = slime_scene.instantiate()
	enemy.position = spwan.position
	game.add_child(enemy)

#func _on_timer_timeout():
	#spawn()
