class_name Shield extends Damager
@onready var player = get_node("/root/Game/Player")
@onready var timer = $Timer

func _ready():
	position = to_local(player.position).normalized()

func _on_timer_timeout():
	queue_free()
