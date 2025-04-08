extends StaticBody2D

@export var damage: int
@export var knockback: int
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")

var targets = []

signal add_target(target: Node2D)
signal remove_target(target: Node2D)

func _ready():
	await animation.animation_finished
	var tile_pos = misc_layer.local_to_map(global_position)
	misc_layer.erase_cell(tile_pos)
	queue_free()

func _on_add_target(target: Node2D) -> void:
	targets.append(target)


func _on_remove_target(target: Node2D) -> void:
	targets.erase(target)


func _on_animated_sprite_2d_frame_changed() -> void:
	if animation.frame == 15:
		for target in targets:
			target.emit_signal("take_damage", damage)
			target.emit_signal("take_knockback", global_position, knockback)
