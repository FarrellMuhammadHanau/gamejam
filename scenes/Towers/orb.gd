extends Node2D
@export var speed = 600

@onready var sprite = $AnimatedSprite2D
var target : Node2D
var level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var projection_animation = "Level %d Projection" % [level]
	sprite.play(projection_animation)

func set_target(body: Node2D):
	target = body
	
func set_level(lvl : int):
	level = lvl
	
func _process(delta):
	if target:
		look_at(target.global_position)
		global_position = global_position.move_toward(target.position, speed * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == target:
		queue_free()
