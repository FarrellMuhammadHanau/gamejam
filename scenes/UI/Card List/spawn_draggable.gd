extends TextureButton

@export var draggable: PackedScene
@export var collection_id: int
@export var price: int
@export var required_wave: int
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")
@onready var ground_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/GroundLayer")
@onready var select_mask: ColorRect =  get_tree().get_current_scene().get_node("WorldLayer/SelectMask")
@onready var info: NinePatchRect = $Info

var draggable_object: Node2D
var is_on_button = false

func _process(delta: float) -> void:
	if Global.gold < price or Global.wave < required_wave:
		set_deferred("disabled", true)
	else:
		set_deferred("disabled", false)

func _input(event) -> void:
	if is_instance_valid(draggable_object) and not Global.is_on_button:
		var mouse_pos = draggable_object.get_global_mouse_position()
		var ground_tile = ground_layer.local_to_map(mouse_pos)
		var misc_tile = misc_layer.local_to_map(mouse_pos)
		if ground_layer.get_cell_source_id(ground_tile) == 0:
			if misc_layer.get_cell_source_id(misc_tile) == -1:
				select_mask.set_deferred("visible", true)
				select_mask.global_position = misc_layer.map_to_local(misc_tile) + Vector2(-32, -32)
				if event is InputEventMouseButton:
					if event.button_index == MOUSE_BUTTON_LEFT:
						Global.gold -= price
						misc_layer.set_cell(misc_tile, collection_id, Vector2i.ZERO, 1)
						draggable_object.queue_free()
						Global.is_holding = false
						select_mask.set_deferred("visible", false)
			else:
				select_mask.set_deferred("visible", false)

func _on_pressed() -> void:
	if not Global.is_holding and not draggable_object:
		draggable_object = draggable.instantiate()
		get_tree().current_scene.add_child(draggable_object)
		Global.current_dragabble = draggable_object
		Global.is_holding = true
		
	elif Global.is_holding and not draggable_object and is_instance_valid(Global.current_dragabble):
		Global.current_dragabble.queue_free()
		draggable_object = draggable.instantiate()
		get_tree().current_scene.add_child(draggable_object)
		Global.current_dragabble = draggable_object
		
	elif is_instance_valid(draggable_object):
		draggable_object.queue_free()
		Global.is_holding = false
		select_mask.set_deferred("visible", false)

func _on_mouse_entered() -> void:
	Global.is_on_button = true
	info.visible = true

func _on_mouse_exited() -> void:
	Global.is_on_button = false
	info.visible = false
