extends StaticBody2D

@export var level: int = 1
@export var health = 800
@onready var base = $Base
@onready var weapon = $Weapon
@onready var spawner = $Weapon/ProjectionSpawner
@onready var health_bar = $HealthBar

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)
signal finished_attacking
signal take_damage(damage: int)

const BASE_RECT = [Rect2(0, 0, 64, 128), Rect2(64, 0, 64, 128), Rect2(128, 0, 64, 128)]

var idle_animation : String
var attack_animation : String
var weapon_pos_y = [-43, -51, -61]
var is_attacking = false
var attack_frame = 5
var targets = []
var target

func _ready() -> void:
	await get_tree().process_frame
	health_bar.max_value = health
	health_bar.value = health
	update_level()
	
func update_level() -> void:
	idle_animation = "Level %d Idle" % [level]
	attack_animation = "Level %d Attack" % [level]
	base.region_rect = BASE_RECT[level - 1]
	
	weapon.position.y = weapon_pos_y[level - 1]
	weapon.play(idle_animation)

func _on_add_target(body: CharacterBody2D) -> void:
	targets.append(body)
	
func _on_remove_target(body: CharacterBody2D) -> void:
	targets.erase(body)
	if target == body:
		if is_attacking:
			await finished_attacking
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
	finished_attacking.emit()

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
		queue_free()
