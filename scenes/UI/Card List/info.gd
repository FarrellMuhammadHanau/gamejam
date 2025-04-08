extends NinePatchRect


@export var required_gold: int
@export var required_wave: int
@export var title: String

@onready var title_label: Label = $VBoxContainer/Title
@onready var gold_label: Label = $"VBoxContainer/RequirementContainer/HBoxContainer/Gold Info"
@onready var wave_label: Label = $"VBoxContainer/RequirementContainer/HBoxContainer/Wave Info"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_label.text = title
	gold_label.text = "Gold %d/%d" % [Global.gold, required_gold]
	wave_label.text = "Wave %d/%d" % [Global.wave, required_wave]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gold_label.text = "Gold %d/%d" % [Global.gold, required_gold]
	wave_label.text = "Wave %d/%d" % [Global.wave, required_wave]
