extends Sprite2D

@export var speed: int

var castle: StaticBody2D
var is_enter = false

func _ready() -> void:
	var castles = get_tree().get_nodes_in_group("Castle")
	if len(castles) > 0 and is_instance_valid(castles[0]):
		castle = castles[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(castle):
		global_position = global_position.move_toward(castle.position, speed * delta)
	elif not is_enter:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == castle:
		is_enter = true
		if Global.gold < Global.max_gold:
			Global.gold += 1
		
		queue_free()
