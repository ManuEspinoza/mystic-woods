class_name Mage extends Enemy
const SPELL = preload("res://Scenes/spell.tscn")

func cast_spell():
	var spell_instance := SPELL.instantiate()
	spell_instance.position = global_position
	spell_instance.direction = global_position.direction_to(player.global_position)
	add_child(spell_instance)
