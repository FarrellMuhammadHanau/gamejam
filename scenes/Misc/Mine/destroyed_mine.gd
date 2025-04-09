extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var build_mine_ui: Node2D = $BuildMineUi
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")

signal build()

var is_clicked = false

func _ready() -> void:
	sprite.material = sprite.material.duplicate()

func _on_click_area_mouse_entered() -> void:
	var mat = sprite.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA

func _on_click_area_mouse_exited() -> void:
	var mat = sprite.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not is_clicked:
			build_mine_ui.visible = true
			is_clicked = true
		else:
			build_mine_ui.visible = false
			is_clicked = false


func _on_build() -> void:
	var misc_tile = misc_layer.local_to_map(global_position)
	misc_layer.erase_cell(misc_tile)
	misc_layer.set_cell(misc_tile, 6, Vector2i.ZERO, 3)
	queue_free()
