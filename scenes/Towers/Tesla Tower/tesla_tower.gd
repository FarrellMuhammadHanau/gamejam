extends StaticBody2D

@export var level: int = 1

@export var health = 1200
@export var damage = 50
@onready var base = $Base
@onready var weapon = $Weapon
@onready var health_bar = $HealthBar
@onready var blast = $Blast

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)
signal take_damage(damage: int)

const BASE_RECT = [Rect2(0, 64, 64, 128), Rect2(64, 64, 64, 128), Rect2(128, 64, 64, 128)]

var idle_animation = "Idle"
var attack_animation = "Attack"
var is_attacking = false
var attack_frame = 8
var targets = []
var target

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health

func _on_add_target(body: CharacterBody2D) -> void:
	targets.append(body)
	
func _on_remove_target(body: CharacterBody2D) -> void:
	targets.erase(body)

func attack() -> void:
	weapon.play(attack_animation)
	is_attacking = true
	
	await weapon.animation_finished
	
	weapon.play(idle_animation)
	is_attacking = false

func _process(delta: float) -> void:
	if targets.size() > 0:
		attack()

func _on_weapon_frame_changed() -> void:
	if is_attacking and weapon.frame == attack_frame:
		print("Test")
		blast.call_deferred("show")
		blast.play("Explode")
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
		queue_free()
