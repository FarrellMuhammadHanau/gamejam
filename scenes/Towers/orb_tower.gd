extends StaticBody2D

@export var level = 1
@onready var base = $Base
@onready var weapon = $Weapon
@onready var spawner = $ProjectionSpawner

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)

var idle_animation : String
var attack_animation : String
var base_rect = [Rect2(0, 0, 64, 128), Rect2(64, 0, 64, 128), Rect2(128, 0, 64, 128)]
var weapon_pos_y = [-60, -70, -85]
var is_attacking = false
var attack_frame = 7
var targets = []
var target

func _ready() -> void:
	idle_animation = "Level %d Idle" % [level]
	attack_animation = "Level %d Attack" % [level]
	base.region_rect = base_rect[level - 1]
	
	weapon.position.y = weapon_pos_y[level - 1]
	weapon.play(idle_animation)

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
	if targets.size() > 0 and not is_attacking:
		target = targets.front()
		attack()


func _on_weapon_frame_changed() -> void:
	if weapon.frame == attack_frame:
		spawner.emit_signal("spawn", target)
