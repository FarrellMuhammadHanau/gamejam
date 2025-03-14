extends CharacterBody2D

enum DIRECTION {UP, DOWN, RIGHT, LEFT}

@export var current_direction = DIRECTION.RIGHT
		
@export var health = 200
@export var speed = 10000

@onready var animSprite = $AnimatedSprite2D
@onready var pathFinder : NavigationAgent2D = $NavigationAgent2D

signal take_damage(damage: int)

var towers = []
var closest = null

func update_direction(dir : DIRECTION) -> void:
	current_direction = dir
	match dir:
		DIRECTION.RIGHT:
			animSprite.play("Side Walk")
			animSprite.flip_h = true
		DIRECTION.LEFT:
			animSprite.play("Side Walk")
			animSprite.flip_h = false
		DIRECTION.UP:
			animSprite.play("Up Walk")
			animSprite.flip_h = false
		DIRECTION.DOWN:
			animSprite.play("Down Walk")
			animSprite.flip_h = true

func _ready() -> void:
	await get_tree().process_frame
	pathFinder.path_desired_distance = 4.0
	pathFinder.target_desired_distance = 4.0
	towers = get_tree().get_nodes_in_group("Tower")
	print(global_position)
	print(towers.size())
	update_direction(current_direction)

func _process(delta: float) -> void:
	if not closest or not is_instance_valid(closest):
		closest = find_closest()
		
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
	
	velocity = target_dir * speed * delta
	move_and_slide()


func _on_take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()

func find_closest() -> Node2D:
	var closest_target = towers.front()
	var closest_range = global_position.distance_to(closest_target.global_position)
	for i in range(towers.size()):
		var current = towers[i]
		var distance = global_position.distance_to(current.global_position)
		if distance < closest_range:
			closest_range = distance
			closest_target = current
			
	return closest_target
