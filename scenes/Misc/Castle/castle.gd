extends StaticBody2D

@export var health: int
@onready var health_bar: TextureProgressBar = $HealthBar
signal take_damage(damage: int)

func _ready() -> void:
	await get_tree().process_frame
	health_bar.max_value = health
	health_bar.value = health

func _on_take_damage(damage: int) -> void:
	health -= damage
	if health > 0:
		health_bar.value = health
	else:
		health_bar.value = 0
		get_tree().quit()
