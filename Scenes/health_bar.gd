extends Control

@onready var texture_progress_bar = $TextureProgressBar

func _on_timer_timeout():
	texture_progress_bar.value -= 1
