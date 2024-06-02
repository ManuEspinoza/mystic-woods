extends Marker2D
signal destroyed_portal
@onready var health_bar = $HealthBar
@onready var health_component = $HealthComponent
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	health_bar.value = health_component.max_health
	
func _on_health_component_health_depleted():
	animated_sprite_2d.play("dead")
	destroyed_portal.emit()

func _on_hurtbox_component_getting_hit():
	health_bar.value = health_component.current_health


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "dead":
		queue_free()
