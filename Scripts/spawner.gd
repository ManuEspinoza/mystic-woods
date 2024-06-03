extends Node2D
const slime_scene := preload("res://Scenes/slime.tscn")
const mage_scene := preload("res://Scenes/mage.tscn")
const warior_scene := preload("res://Scenes/warior.tscn")
const PORTAL = preload("res://Scenes/portal.tscn")
signal all_portals_destroyed
@onready var timer = $Timer
@onready var game = get_node("/root/Game")
@onready var top_left_limit = get_parent().top_left
@onready var bot_right_limit = get_parent().bot_right
var acceptale_distance = 100
var portals := []
# Called when the node enters the scene tree for the first time.
func _ready():
	#inovoike_portals()
	populate_portals()
	timer.start()
func _on_timer_timeout():
	spawn()

func _on_child_exiting_tree(node):
	populate_portals()

func populate_portals(): 
	portals = []
	for i in get_children(true):
		if i is Marker2D and not i.is_queued_for_deletion():
			portals.append(i)
	if portals.size() <= 0:
		all_portals_destroyed.emit()
		
func spawn():
	#pick random spawner
	randomize()
	if !portals.size():
		return
	var portal = portals[randi() % portals.size()]
	var enemy = choose_enemie()
	if portal != null:
		enemy.position = portal.position
		game.add_child(enemy)

func choose_enemie():
	randomize()
	var i = randf_range(0.0, 1.0)
	if i < 0.5:
		return slime_scene.instantiate()
	elif i > 0.5 && i < 0.9:
		return warior_scene.instantiate()
	else:
		return mage_scene.instantiate()
   
#Portals randomize position
func inovoike_portals():
	for n in 4:
		var random_vector = Vector2.ZERO
		var recalculate_distance = true
		while recalculate_distance:
			randomize()
			var x_position = randi_range(top_left_limit.x, bot_right_limit.x)
			var y_position = randi_range(bot_right_limit.y, top_left_limit.y)
			random_vector = Vector2(x_position, y_position)
			recalculate_distance = acceptale_distance_between_portals(random_vector)
			
		var portal = PORTAL.instantiate()
		portal.position = random_vector
		add_child(portal)
		portals.append(portal)

#For portals randomize position
func acceptale_distance_between_portals(new_portal_position):
	if !portals.size():
		return false
	if new_portal_position == Vector2.ZERO:
		return true
	for portal in portals:
		var distance_between_portals = portal.position.distance_to(new_portal_position)
		if distance_between_portals < acceptale_distance:
			return true
	return false
	

