extends Node2D

const ENEMY = preload("res://Enemy/enemy.tscn")
var spawn_max = 160
var spawn_count = 0
var enemy_health = 1.0
var enemy_damage = 5.0
var enemy_speed = 50.0
var loved_speed = 80.0

var souls_needed = 3
var souls_collected = 0

var hearts_need = 20
var hearts_collected = 0

const PLAYER = preload("res://Player/player.tscn")
var player_speed = 125.0
var player_damage = 1

var arrow_range = 1000
var arrow_speed = 350

var game_controller

var isLevelPassed = false

func _ready():
	game_controller = get_parent().get_parent()
	game_controller.update_soul_progress_max(souls_needed)
	game_controller.set_soul_progress()
	call_deferred("spawn_player")
	call_deferred("spawn_enemy")

func spawn_player():
	var player = PLAYER.instantiate()
	player.global_position = %PlayerSpawn.global_position
	add_child(player)

func spawn_enemy():
	if spawn_count < spawn_max:
		spawn_count += 1
		var new_enemy = ENEMY.instantiate()
		%PathFollow2D.progress_ratio = randf()
		new_enemy.global_position = %PathFollow2D.global_position
		add_child(new_enemy)

func get_arrow_speed():
	return arrow_speed

func get_arrow_range():
	return arrow_range

func get_hearts_needed():
	return hearts_need

func get_hearts_collected():
	return hearts_collected
	
func add_heart():
	hearts_collected += 1
	update_player_health(get_player_health()+3.0)
	game_controller.update_heart_label(hearts_collected)
	if hearts_collected >= hearts_need:
		%Wings.unlock()

func get_souls_needed():
	return souls_needed

func get_souls_collected():
	return souls_collected

func add_soul():
	souls_collected += 1
	game_controller.update_soul_progress(souls_collected,souls_needed)
	
func reset_souls():
	souls_collected -= souls_needed
	game_controller.update_soul_progress(souls_collected,souls_needed)

func hide_heart_arrow_key():
	game_controller.hide_heart_arrow_key()
	
func get_player_health():
	return game_controller.get_player_health()

func update_player_health(value: int):
	game_controller.update_health(value)

func get_player_speed():
	return player_speed

func get_player_damage():
	return player_damage

func get_enemy_health():
	return enemy_health

func get_enemy_speed():
	return enemy_speed

func get_loved_speed():
	return loved_speed

func get_enemy_damage():
	return enemy_damage

func _on_enemy_spawn_timer_timeout():
	if !isLevelPassed: call_deferred("spawn_enemy")
	
func level_passed():
	isLevelPassed = true
	game_controller.load_next_level(true)
