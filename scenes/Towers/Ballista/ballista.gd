extends StaticBody2D

@export var level: int = 1

@export var health = 500
@onready var base = $Base
@onready var weapon = $Weapon
@onready var spawner = $Weapon/ProjectionSpawner
@onready var health_bar = $HealthBar

signal add_target(body: CharacterBody2D)
signal remove_target(body: CharacterBody2D)
signal take_damage(damage: int)

const BASE_RECT = [Rect2(0, 0, 64, 128), Rect2(64, 0, 64, 128), Rect2(128, 0, 64, 128)]

var idle_animation : String
var attack_animation : String
var weapon_pos_y = [-43, -53, -61]
var is_attacking = false
var attack_frame = 4
var targets = []
var target

func _ready() -> void:
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
	if body and body == target:
		target = null

func find_closest_target() -> Node2D:
	var closest_target = targets.front()
	var highest_health = closest_target.health
	var closest_range = position.distance_to(closest_target.position)
	for i in range(targets.size()):
		var current = targets[i]
		var distance = position.distance_to(current.position)
		var health = current.health
		if health > highest_health:
			closest_target = current
			highest_health = health
			closest_range = distance
		elif health == highest_health and distance < closest_range:
			closest_target = current
			highest_health = health
			closest_range = distance
			
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
	
	var direction = (target.global_position - global_position).normalized()
	var angle = atan2(direction.y, direction.x)

	weapon.rotation = angle
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
