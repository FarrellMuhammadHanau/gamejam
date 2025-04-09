extends CharacterBody2D

enum DIRECTION {UP, DOWN, RIGHT, LEFT}

@export var current_direction = DIRECTION.RIGHT
		
@export var health = 1000
@export var speed = 50
@export var damage = 30
@export var weight = 5
@export var gold_spawn_rate: int
@export var gold : PackedScene

@onready var animSprite = $AnimatedSprite2D
@onready var pathFinder : NavigationAgent2D = $NavigationAgent2D
@onready var health_bar : TextureProgressBar = $HealthBar
@onready var collision = $CollisionShape2D

signal take_damage(damage: int)
signal take_knockback(anchor: Vector2, knockback: int)
signal reached(target: Node2D)
signal unreached(target: Node2D)
signal add_tower(tower: StaticBody2D)

var towers = []
var closest = null
var reached_towers = []
var is_attacking = false
var is_death = false

func update_direction(dir : DIRECTION) -> void:
	current_direction = dir
	match dir:
		DIRECTION.RIGHT:
			if is_death:
				animSprite.play("Side Death")
			elif reached_towers.size() > 0:
				animSprite.play("Side Attack")
			else:
				animSprite.play("Side Walk")
			animSprite.flip_h = true
		DIRECTION.LEFT:
			if is_death:
				animSprite.play("Side Death")
			elif reached_towers.size() > 0:
				animSprite.play("Side Attack")
			else:
				animSprite.play("Side Walk")
			animSprite.flip_h = false
		DIRECTION.UP:
			if is_death:
				animSprite.play("Up Death")
			elif reached_towers.size() > 0:
				animSprite.play("Up Attack")
			else:
				animSprite.play("Up Walk")
			animSprite.flip_h = false
		DIRECTION.DOWN:
			if is_death:
				animSprite.play("Down Death")
			elif reached_towers.size() > 0:
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
	if is_death:
		pathFinder.set_velocity(Vector2.ZERO)
		return
		
	if is_attacking:
		pathFinder.set_velocity(Vector2.ZERO)
		return
	
	if towers.size() == 0:
		pathFinder.set_velocity(Vector2.ZERO)
		return
	
	if not closest or not is_instance_valid(closest):
		closest = find_closest()
		if not closest:
			pathFinder.set_velocity(Vector2.ZERO)
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
		pathFinder.set_velocity(Vector2.ZERO)
		attack()
		return
	
	pathFinder.set_velocity(target_dir * speed)

func _on_take_damage(damage: int) -> void:
	if not is_death:
		health -= damage
		if health > 0:
			health_bar.value = health
		else:
			health_bar.value = 0
			is_death = true
			collision.set_deferred("disabled", true)
			update_direction(current_direction)
			
			if randi() % gold_spawn_rate == 0:
				var gold_instance = gold.instantiate()
				get_tree().get_root().call_deferred("add_child", gold_instance)
				gold_instance.global_position = global_position
				
			await animSprite.animation_finished
			get_tree().current_scene.emit_signal("remove_enemy")
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
	if is_attacking and animSprite.frame == 8 and not is_death:
		if is_instance_valid(closest):
			closest.emit_signal("take_damage", damage)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_take_knockback(anchor: Vector2, knockback: int) -> void:
	var direction = (global_position - anchor).normalized()
	move_and_collide(direction * (knockback/weight))

func _on_add_tower(tower: StaticBody2D) -> void:
	if tower.is_in_group("Tower"):
		towers.append(tower)
		if not is_attacking:
			closest = find_closest()
