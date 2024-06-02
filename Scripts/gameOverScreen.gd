extends CanvasLayer
@export var title: Label

func _ready():
	print("aparecí")
func set_title(win):
	if win:
		title.text = "YOU WIN"
	else:
		title.text = "YOU LOSE"

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().root.get_child(0).reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
