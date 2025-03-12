extends CharacterBody2D

@export var speed: float = 200.0  # Kecepatan karakter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO  # Mulai dari diam

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()  # Biar diagonal tetap seimbang
	velocity = direction * speed  # Hitung kecepatan
	move_and_slide()  # Jalankan movement
