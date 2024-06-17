extends ProgressBar
@export var player: Player

func _ready():
	max_value = player.final_attack_cooldown_timer.time_left
	value = player.final_attack_cooldown_timer.time_left

func _process(delta):
	value = player.final_attack_cooldown_timer.time_left
