extends Camera2D

var dragging := false
var last_mouse_position := Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
				last_mouse_position = event.position
			else:
				dragging = false
	
	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_position
		var new_position = position - delta
		var moved := false

		var half_screen = get_viewport_rect().size / 2

		if new_position.x - half_screen.x >= limit_left and new_position.x + half_screen.x <= limit_right:
			position.x = new_position.x
			moved = true
		elif new_position.x - half_screen.x < limit_left:
			position.x = limit_left + half_screen.x
			moved = true
		elif new_position.x + half_screen.x > limit_right:
			position.x = limit_right - half_screen.x
			moved = true

		if new_position.y - half_screen.y >= limit_top and new_position.y + half_screen.y <= limit_bottom:
			position.y = new_position.y
			moved = true
		elif new_position.y - half_screen.y < limit_top:
			position.y = limit_top + half_screen.y
			moved = true
		elif new_position.y + half_screen.y > limit_bottom:
			position.y = limit_bottom - half_screen.y
			moved = true

		if moved:
			last_mouse_position = event.position
