extends Node2D
@export var speed = 700

@onready var sprite = $AnimatedSprite2D
var target : Node2D
var level = 1
var base_damage = 20
var is_enter = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var projection_animation = "Level %d Projection" % [level]
	scale = Vector2(1 + (level-1.0)/5, 1 + (level-1.0)/5)
	sprite.play(projection_animation)

func set_target(body: Node2D):
	target = body
	
func set_level(lvl : int):
	level = lvl

func _process(delta):
	if target and is_instance_valid(target):
		global_position = global_position.move_toward(target.position, speed * delta)
		if not is_enter:
			look_at(target.global_position)
	elif not is_enter:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == target:
		is_enter = true
		var damage = base_damage + base_damage * (level - 1) / 2
		body.emit_signal("take_damage", damage)
		
		var impact_animation = "Level %d Impact" % [level]
		sprite.play(impact_animation)
		await sprite.animation_finished
		
		queue_free()
