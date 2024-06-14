class_name FinalAttack extends Node2D
@export var animation_player: AnimationPlayer
const FINAL_ATTACK = "attack"

func execute():
	animation_player.play(FINAL_ATTACK)
