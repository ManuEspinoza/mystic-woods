class_name FinalAttack extends Node2D
@export var animation_player: AnimationPlayer

func _ready():
	animation_player.play("RESET")


func _on_animation_player_animation_finished(anim_name):
	queue_free()
