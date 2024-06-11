class_name Shield extends Damager
@onready var player: Player = get_node("/root/Game/Player")
@onready var timer = $Timer
@export var INVENCIBILITY_TIME = 3

func _ready():
	position = to_local(player.position).normalized()
	player.damage_timer.start(3)

func _on_timer_timeout():
	queue_free()
