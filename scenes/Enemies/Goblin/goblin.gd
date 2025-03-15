extends CharacterBody2D

enum DIRECTION {UP, DOWN, RIGHT, LEFT}

@export var current_direction = DIRECTION.RIGHT
		
@export var health = 200
@export var speed = 10000
@export var damage = 40

@onready var animSprite = $AnimatedSprite2D
@onready var pathFinder : NavigationAgent2D = $NavigationAgent2D
@onready var health_bar = $HealthBar

signal take_damage(damage: int)
signal reached(target: Node2D)
signal unreached(target: Node2D)

var towers = []
var closest = null
var reached_towers = []
var is_attacking = false

func update_direction(dir : DIRECTION) -> void:
	current_direction = dir
	match dir:
		DIRECTION.RIGHT:
			if reached_towers.size() > 0:
				animSprite.play("Side Attack")
			else:
				animSprite.play("Side Walk")
			animSprite.flip_h = true
		DIRECTION.LEFT:
			if reached_towers.size() > 0:
				animSprite.play("Side Attack")
			else:
				animSprite.play("Side Walk")
			animSprite.flip_h = false
		DIRECTION.UP:
			if reached_towers.size() > 0:
				animSprite.play("Up Attack")
			else:
				animSprite.play("Up Walk")
			animSprite.flip_h = false
		DIRECTION.DOWN:
			if reached_towers.size() > 0:
				animSprite.play("Down Attack")
			else:
				animSprite.play("Down Walk")
			animSprite.flip_h = true

func _ready() -> void:
	await get_tree().process_frame
	pathFinder.path_desired_distance = 10
	pathFinder.target_desired_distance = 10
	towers = get_tree().get_nodes_in_group("Tower")
	update_direction(current_direction)
	health_bar.max_value = health
	health_bar.value = health

func _process(delta: float) -> void:
	if is_attacking:
		return
	
	if towers.size() == 0:
		return
	
	if not closest or not is_instance_valid(closest):
		closest = find_closest()
		if not closest:
			return
		
	
	pathFinder.target_position = closest.global_position
	var target_dir = pathFinder.get_next_path_position() - global_position
	target_dir = target_dir.normalized()
	
	var angle = rad_to_deg(atan2(target_dir.y, target_dir.x))
	if angle < 0:
		angle += 360
		
	if angle >= 315 or angle < 45:
		update_direction(DIRECTION.RIGHT)
	elif angle >= 45 and angle < 135:
		update_direction(DIRECTION.DOWN)
	elif angle >= 135 and angle < 225:
		update_direction(DIRECTION.LEFT)
	elif angle >= 225 and angle < 315:
		update_direction(DIRECTION.UP)
	
	if closest in reached_towers:
		attack()
		return
	
	velocity = target_dir * speed * delta
	move_and_slide()

func _on_take_damage(damage: int) -> void:
	health -= damage
	if health > 0:
		health_bar.value = health
	else:
		health_bar.value = 0
		call_deferred("queue_free")
		
func attack() -> void:
	is_attacking = true
	await animSprite.animation_finished
	is_attacking = false

func find_closest() -> Node2D:
	var closest_target = towers.front()
	var closest_range = INF
	for i in range(towers.size()):
		var current = towers[i]
		if not is_instance_valid(current):
			continue
		var distance = global_position.distance_to(current.global_position)
		if distance < closest_range:
			closest_range = distance
			closest_target = current
	 
	towers = towers.filter(is_instance_valid)
	
	if not is_instance_valid(closest_target):
		return null
	return closest_target

func _on_reached(target: Node2D) -> void:
	if target.is_in_group("Tower"):
		reached_towers.append(target)

func _on_unreached(target: Node2D) -> void:
	if target in reached_towers:
		reached_towers.erase(target)


func _on_animated_sprite_2d_frame_changed() -> void:
	if is_attacking and animSprite.frame == 4:
		if is_instance_valid(closest):
			closest.emit_signal("take_damage", damage)
