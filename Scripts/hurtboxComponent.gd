class_name HurtboxComponent extends Area2D
signal getting_hit
@export var health_component: HealthComponent

func _on_area_entered(area):
	if area.is_in_group("Sword"):
		health_component.take_damage(area.damage)
		getting_hit.emit()
