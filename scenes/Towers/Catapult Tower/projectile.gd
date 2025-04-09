extends Node2D
@export var speed = 500

@onready var sprite = $AnimatedSprite2D
@onready var area_damage = $AreaDamage/CollisionShape2D
@export var damage: int = 60

var is_enter = false
var projection_animation
var target_global_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	projection_animation = "Projection"
	sprite.play(projection_animation)

func set_target(body: Node2D):
	target_global_pos = body.global_position

func _process(delta):
	if global_position != target_global_pos:
		global_position = global_position.move_toward(target_global_pos, speed * delta)
		look_at(target_global_pos)
	else:
		attack()

func attack():
	var impact_animation = "Impact"
	area_damage.call_deferred("set", "disabled", false)
	sprite.play(impact_animation)
	await sprite.animation_finished
	call_deferred("queue_free")

func _on_area_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and is_instance_valid(body):
		body.emit_signal("take_damage", damage)
