extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "%d/%d" % [Global.wave, Global.max_wave]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%d/%d" % [Global.wave, Global.max_wave]
