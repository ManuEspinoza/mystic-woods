extends Node2D
const slime_scene := preload("res://Scenes/slime.tscn")
const mage_scene := preload("res://Scenes/mage.tscn")
const warior_scene := preload("res://Scenes/warior.tscn")
const PORTAL = preload("res://Scenes/portal.tscn")
@onready var timer = $Timer
@onready var game = get_node("/root/Game")
var portals := []
# Called when the node enters the scene tree for the first time.
func _ready():
	populate_portals()
	timer.start()
	spawn()
	
func populate_portals(): 
	portals = []
	for i in get_children(true):
		if i is Marker2D and not i.is_queued_for_deletion():
			portals.append(i)
			
func spawn():
	#pick random spawner
	var portal = portals[randi() % portals.size()]
	var enemy = slime_scene.instantiate()
	if portal != null:
		enemy.position = portal.position
		game.add_child(enemy)
	

func _on_timer_timeout():
	spawn()

func _on_portal_destroyed_portal():
	populate_portals() 
