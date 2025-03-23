extends Node2D
@export var speed = 500

@onready var sprite = $AnimatedSprite2D
var target : Node2D
var level = 1
var damage : int
var is_enter = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("Idle")

func set_target(body: Node2D):
	target = body
	
func set_damage(new_damage : int):
	damage = new_damage

func _process(delta):
	if not is_enter and target and is_instance_valid(target):
		global_position = global_position.move_toward(target.position, speed * delta)
		look_at(target.global_position)
	elif not is_enter:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == target:
		print("Test")
		is_enter = true
		body.emit_signal("take_damage", damage)
		
		sprite.play("Explode")
		await sprite.animation_finished
		
		queue_free()
