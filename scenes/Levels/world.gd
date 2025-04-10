extends Node2D

@onready var wave_bar : TextureProgressBar = $CanvasLayer/WaveInfo/WaveBar

var spawners: Array
var is_wave_begining = true
var enemies_amount : int

signal remove_enemy()

func _ready() -> void:
	Engine.time_scale = 1
	Engine.max_fps = 120

	spawners = [
		$EnemiesSpawners/Spawner1, 
		$EnemiesSpawners/Spawner2, 
		$EnemiesSpawners/Spawner3, 
		$EnemiesSpawners/Spawner4, 
		$EnemiesSpawners/Spawner5, 
		$EnemiesSpawners/Spawner6
	]
	#save_script()
	
func _process(delta: float) -> void:
	if is_wave_begining:
		is_wave_begining = false
		load_data()
	elif enemies_amount == 0:
		Global.wave += 1
		Global.max_gold += 5
		if Global.wave > Global.max_wave:
			get_tree().quit()
		is_wave_begining = true
		
func load_data():
	wave_bar.max_value = 0
	for i in range(6):
		var file_path = "res://resources/Wave/Wave %d/spawner%d.tres" % [Global.wave, i + 1]
		if not ResourceLoader.exists(file_path):
			continue
			
		var enemies = ResourceLoader.load(file_path).enemies
		enemies_amount += len(enemies)
		spawners[i].load_enemies(enemies)
		spawners[i].spawn_enemies()
	wave_bar.max_value = enemies_amount
	wave_bar.value = enemies_amount

func save_script():
	for i in range(6):
		for j in range(6):
			var file_path = "res://scripts/Wave/Wave %d/spawner%d.gd" % [i + 1, j + 1]
			if not FileAccess.file_exists(file_path):
				continue
			var resource = load(file_path).new()
			ResourceSaver.save(resource, "res://resources/Wave/Wave %d/spawner%d.tres" % [i + 1, j + 1])


func _on_remove_enemy() -> void:
	enemies_amount -= 1
	wave_bar.value = enemies_amount

func _exit_tree():
	for child in $WorldLayer/ElevationLayer.get_children():
		if child is StaticBody2D:
			# Clear semua signal terlebih dahulu
			for signal_connection in child.get_signal_connection_list("tree_entered"):
				if child.is_connected(signal_connection["signal"], signal_connection["callable"]):
					child.disconnect(signal_connection["signal"], signal_connection["callable"])
