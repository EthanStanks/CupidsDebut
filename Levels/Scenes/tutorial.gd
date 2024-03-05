extends Node2D

const ENEMY = preload("res://Enemy/tutorial_enemy.tscn")
var enemy_health = 2.0
var loved_speed = 50.0

var isLevelPassed = false

var souls_needed = 2
var souls_collected = 0

var killed = 0

var hearts_need = 1
var hearts_collected = 0

const PLAYER = preload("res://Player/player.tscn")
var player_speed = 125.0
var player_damage = 1

var arrow_range = 1000
var arrow_speed = 350

var game_controller
var enemies = []

func _ready():
	game_controller = get_parent().get_parent()
	game_controller.update_soul_progress_max(souls_needed)
	game_controller.set_soul_progress()
	call_deferred("spawn_player")
	call_deferred("spawn_enemies")

func spawn_player():
	var player = PLAYER.instantiate()
	player.global_position = %PlayerSpawn.global_position
	add_child(player)

func spawn_enemies():
	var enemy1 = ENEMY.instantiate()
	enemy1.global_position = %EnemySpawn1.global_position
	add_child(enemy1)
	enemies.append(enemy1)
	
	var enemy2 = ENEMY.instantiate()
	enemy2.global_position = %EnemySpawn2.global_position
	add_child(enemy2)
	enemies.append(enemy2)
	
	var enemy3 = ENEMY.instantiate()
	enemy3.global_position = %EnemySpawn3.global_position
	add_child(enemy3)
	enemies.append(enemy3)
	
	var enemy4 = ENEMY.instantiate()
	enemy4.global_position = %EnemySpawn4.global_position
	add_child(enemy4)
	enemies.append(enemy4)

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
	game_controller.update_heart_label(hearts_collected)

func get_souls_needed():
	return souls_needed

func get_souls_collected():
	return souls_collected

func add_soul():
	souls_collected += 1
	killed += 1
	if killed >= 3:
		killed = 0
		for enemy in enemies:
			if enemy != null:
				enemy.queue_free()
		enemies.clear()
		call_deferred("spawn_enemies")
		
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
	return 0.0

func get_loved_speed():
	return loved_speed

func get_enemy_damage():
	return 0
	
func level_passed():
	isLevelPassed = true
	game_controller.finished_tutorial()


func _on_first_sign_body_entered(_body):
	%Label1.show()


func _on_first_sign_body_exited(_body):
	%Label1.hide()


func _on_second_sign_body_entered(_body):
	%Label2.show()


func _on_second_sign_body_exited(_body):
	%Label2.hide()


func _on_third_sign_body_entered(_body):
	%Label3.show()


func _on_third_sign_body_exited(_body):
	%Label3.hide()


func _on_fourth_sign_body_entered(_body):
	%Label4.show()


func _on_fourth_sign_body_exited(_body):
	%Label4.hide()
