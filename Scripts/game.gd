extends Node2D
@export var top_left := Vector2(1,1) # your co-ords here
@export var bot_right := Vector2(500,410) # your co-ords here
@onready var timer = $Timer
const GAME_OVER_SCREEN = preload("res://Scenes/game_over_screen.tscn")
const TUTORIAL_SCREEN = preload("res://Scenes/tutorial_screen.tscn")
const PAUSE_SCREEN = preload("res://Scenes/pause_screen.tscn")
const PAUSE = "pause"
var all_portals_destroyed := false
var enemy_count = 0

func _input(event):
	if event.is_action_pressed(PAUSE):
		var pause_screen := PAUSE_SCREEN.instantiate()
		add_child.call_deferred(pause_screen)
		
func _ready():
	var tutorial_screen := TUTORIAL_SCREEN.instantiate()
	add_child.call_deferred(tutorial_screen)

func _on_player_health_depleted():
	Engine.time_scale = 0.5
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	game_over(false)

func _on_spawner_all_portals_destroyed():
	all_portals_destroyed = true
	if enemy_count <= 0:
		game_over(true)

func _on_child_exiting_tree(node):
	if node is Enemy:
		discount_enemies()
func _on_child_entered_tree(node):
	if node is Enemy:
		enemy_count += 1

func discount_enemies():
	enemy_count -= 1
	if enemy_count <= 0 && all_portals_destroyed:
		game_over(true)

func game_over(win):
	var game_over_screen := GAME_OVER_SCREEN.instantiate()
	add_child.call_deferred(game_over_screen)
	game_over_screen.set_title(win)
