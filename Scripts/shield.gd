extends Damager
@onready var player = get_node("/root/Game/Player")

func _ready():
	position = to_local(player.position).normalized()


func _on_timer_timeout():
	queue_free()
