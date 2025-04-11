extends Control

@onready var title = $TitleCarve/Title
@onready var win_title = $TitleCarve/Win
@onready var lose_title = $TitleCarve/Lose
@onready var mask = $BackgroundMask
@onready var restart_button = $MainCarve/RestartButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.is_win:
		title.visible = false
		win_title.visible = true
		lose_title.visible = false
		mask.color = Color("#003c008c")
	elif Global.is_lose:
		title.visible = false
		win_title.visible = false
		lose_title.visible = true
		mask.color = Color("#3c00008c")
	else:	
		title.visible = true
		win_title.visible = false
		lose_title.visible = false
		mask.color = Color("#0000008c")


func _on_restart_button_pressed() -> void:
	Global.reset()
	Global.is_reload = true
	get_tree().reload_current_scene()

func continue_game():
	visible = false
	Engine.time_scale = 1
	Global.paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	if Global.is_win or Global.is_lose:
		Global.reset()
		Global.is_reload = true
		get_tree().reload_current_scene()
	else:
		continue_game()
