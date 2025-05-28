extends StaticBody2D

@export var health : int
@export var max_health : int
@export var burst_damage : int = 30

@onready var base = $Base
@onready var weapon = $Weapon
@onready var spawner = $Weapon/ProjectionSpawner
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")
@onready var range_indicator: Node2D = $RangeIndicator
@onready var burst_animation : AnimatedSprite2D = $Burst
@onready var burst_area : Area2D = $BurstArea
@onready var burst_sound : AudioStreamPlayer2D = $BurstSound

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)
signal take_damage(damage: int)

var idle_animation : String = "Idle"
var attack_animation : String = "Attack"
var is_attacking = false
var attack_frame = 5
var targets = []
var target
var burst_targets = []

func _ready() -> void:
	await get_tree().process_frame
	
	base.material = base.material.duplicate()
	weapon.material = weapon.material.duplicate()
	
	health_bar.max_value = health
	health_bar.value = health
	weapon.play(idle_animation)
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	burst_animation.play("default")
	burst_sound.play()
	await burst_animation.animation_finished
	burst_area.set_deferred("monitoring", false)
	burst_area.set_deferred("visible", false)
	burst_animation.set_deferred("visible", false)
	
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy.emit_signal("add_tower", self)

func _on_add_target(body: CharacterBody2D) -> void:
	targets.append(body)
	
func _on_remove_target(body: CharacterBody2D) -> void:
	targets.erase(body)
	if body and body == target:
		target = null

func find_closest_target() -> Node2D:
	var closest_target = targets.front()
	var closest_range = position.distance_to(closest_target.position)
	for i in range(targets.size()):
		var current = targets[i]
		var distance = position.distance_to(current.position)
		if distance < closest_range:
			closest_range = distance
			closest_target = current
			
	return closest_target

func attack() -> void:
	weapon.play(attack_animation)
	is_attacking = true
	
	await weapon.animation_finished
	
	weapon.play(idle_animation)
	is_attacking = false

func _process(delta: float) -> void:
	if not target and targets.size() > 0:
		target = find_closest_target()
	if not target:
		return
	
	weapon.look_at(target.global_position)
	weapon.rotation_degrees += 90
	if not is_attacking:
		attack()

func _on_weapon_frame_changed() -> void:
	if weapon.frame == attack_frame and is_instance_valid(target):
		spawner.emit_signal("spawn", target)

func _on_take_damage(damage: int) -> void:
	health -= damage
	if health > 0:
		health_bar.value = health
	else:
		health_bar.value = 0
		var tile_pos = misc_layer.local_to_map(global_position)
		misc_layer.erase_cell(tile_pos)
		queue_free()


func _on_mouse_area_mouse_entered() -> void:
	var mat = base.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA
	mat = weapon.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_PREMULT_ALPHA
	range_indicator.visible = true

func _on_mouse_area_mouse_exited() -> void:
	var mat = base.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	mat = weapon.material as CanvasItemMaterial
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_MIX
	range_indicator.visible = false

func _on_burst_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body not in burst_targets:
		burst_targets.append(body)
		body.emit_signal("take_damage", burst_damage)
