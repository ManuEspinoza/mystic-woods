extends Node2D
@export var top_left := Vector2(1,1) # your co-ords here
@export var bot_right := Vector2(500,410) # your co-ords here
@onready var timer = $Timer
const GAME_OVER_SCREEN = preload("res://Scenes/game_over_screen.tscn")
var all_portals_destroyed := false
var enemy_count = 0

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
	add_child(game_over_screen)
	game_over_screen.set_title(win)
	get_tree().paused = true
