extends CharacterBody2D

@export var speed: float = 200.0  
@export var health = 100
signal take_damage(damage: int)

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO  # Mulai dari diam

	if Input.is_action_pressed("custom_right"):
		direction.x += 1
	if Input.is_action_pressed("custom_left"):
		direction.x -= 1
	if Input.is_action_pressed("custom_down"):
		direction.y += 1
	if Input.is_action_pressed("custom_up"):
		direction.y -= 1

	direction = direction.normalized()  # Biar diagonal tetap seimbang
	velocity = direction * speed  # Hitung kecepatan
	move_and_slide()  # Jalankan movement


func _on_take_damage(damage: int) -> void:
	health -= damage
	print("%s: %d" % [name, health])
	if health <= 0:
		queue_free()
