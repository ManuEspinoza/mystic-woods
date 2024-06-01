extends CanvasLayer
@onready var title = $PanelContainer/MarginContainer/Rows/Title


func set_title(win):
	if win:
		title.text = "YOU WIN"
		#title.module = Color.GREEN
	else:
		title.text = "YOU LOSE"
		#title. = Color.RED

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_pressed():
	get_tree().quit()
