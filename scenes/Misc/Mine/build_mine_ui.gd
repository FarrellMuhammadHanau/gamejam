extends Node2D

@export var price: int = 20
@onready var price_label : Label = $PriceLabel
@onready var button: TextureButton = $TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	price_label.text = "%d" % [price]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.gold < price:
		price_label.label_settings.font_color = Color("#960000")
		button.disabled = true
	else:
		price_label.label_settings.font_color = Color("#000000")
		button.disabled = false


func _on_texture_button_pressed() -> void:
	Global.gold -= price
	get_parent().emit_signal("build")
