extends Node

var is_holding = false
var gold = 10
var max_gold = 10
var wave = 1
var max_wave = 6
var is_on_button = false
var current_dragabble: Node2D
var paused = true
var game_name = "Bastion Below"
var is_win = false
var is_lose = false
var is_reload = false

func reset():
	gold = 10
	max_gold = 10
	wave = 1
	max_wave = 6
	is_holding = false
	is_on_button = false
	current_dragabble = null
	paused = true
	is_win = false
	is_lose = false
	is_reload = false
