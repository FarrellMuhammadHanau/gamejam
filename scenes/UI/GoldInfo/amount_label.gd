extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "%d/%d" % [Global.gold, Global.max_gold]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "%d/%d" % [Global.gold, Global.max_gold]
