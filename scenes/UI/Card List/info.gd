extends NinePatchRect


@export var required_gold: int
@export var required_wave: int
@export var title: String

@onready var title_label: Label = $VBoxContainer/Title
@onready var gold_label: Label = $"VBoxContainer/RequirementContainer/HBoxContainer/MarginContainer/Gold Info"
@onready var wave_label: Label = $"VBoxContainer/RequirementContainer/HBoxContainer/Wave Info"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gold_label.label_settings = gold_label.label_settings.duplicate()
	wave_label.label_settings = wave_label.label_settings.duplicate()
	title_label.text = title
	gold_label.text = "%d" % [required_gold]
	wave_label.text = "Wave %d" % [required_wave]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.gold < required_gold:
		gold_label.label_settings.font_color = Color("#960000")
	else:
		gold_label.label_settings.font_color = Color("#000000")
	if Global.wave < required_wave:
		wave_label.label_settings.font_color = Color("#960000")
	else:
		wave_label.label_settings.font_color = Color("#000000")
