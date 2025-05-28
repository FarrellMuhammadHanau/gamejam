extends StaticBody2D

@export var health : int
@export var max_health: int
@export var burst_damage : int = 30

@export var damage = 60
@onready var base = $Base
@onready var weapon = $Weapon
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var blast = $Blast
@onready var misc_layer: TileMapLayer = get_tree().get_current_scene().get_node("WorldLayer/MiscLayer")
@onready var range_indicator : Panel = $RangeIndicator
@onready var blast_sound : AudioStreamPlayer2D = $BlastSound
@onready var burst_animation : AnimatedSprite2D = $Burst
@onready var burst_area : Area2D = $BurstArea
@onready var burst_sound : AudioStreamPlayer2D = $BurstSound

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)
signal take_damage(damage: int)

var idle_animation = "Idle"
var attack_animation = "Attack"
var is_attacking = false
var attack_frame = 8
var targets = []
var target
var burst_targets = []

func _ready() -> void:
	base.material = base.material.duplicate()
	weapon.material = weapon.material.duplicate()
	
	health_bar.max_value = max_health
	health_bar.value = health
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

func attack() -> void:
	is_attacking = true
	weapon.play(attack_animation)
	await weapon.animation_finished
	
	weapon.play(idle_animation)
	is_attacking = false

func _process(delta: float) -> void:
	if targets.size() > 0 and not is_attacking:
		attack()

func _on_weapon_frame_changed() -> void:
	if is_attacking and weapon.frame == attack_frame:
		blast.call_deferred("show")
		blast.play("Explode")
		blast_sound.play()
		for target in targets:
			target.emit_signal("take_damage", damage)
		await blast.animation_finished
		blast.call_deferred("hide")
		
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
