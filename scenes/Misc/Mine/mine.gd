extends StaticBody2D

@export var health: int
@export var gold_produced: int

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")
@onready var gold_spawner: Node2D = $GoldSpawner

signal take_damage(damage: int)

var is_filled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	var enemies = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.emit_signal("add_tower", self)

func _on_timer_timeout() -> void:
	if not is_filled:
		is_filled = true
		sprite.play("Full")
	else:
		is_filled = false
		sprite.play("Empty")
		gold_spawner.emit_signal("spawn_gold", gold_produced)

func _on_take_damage(damage: int) -> void:
	health -= damage
	if health > 0:
		health_bar.value = health
	else:
		health_bar.value = 0
		var misc_tile = misc_layer.local_to_map(global_position)
		misc_layer.erase_cell(misc_tile)
		misc_layer.set_cell(misc_tile, 6, Vector2i.ZERO, 2)
		queue_free()
