extends CanvasLayer
@export var title: Label

func _ready():
	get_tree().paused = true
	
func set_title(win):
	if win:
		title.text = "YOU WIN"
	else:
		title.text = "YOU LOSE"

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	queue_free()

func _on_quit_pressed():
	get_tree().quit()
