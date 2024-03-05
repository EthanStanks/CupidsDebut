extends Control

@onready var hud: Control = %HUD
@onready var menu: Control = %MainMenu
@onready var pause: Control = %PauseMenu
@onready var main_2d = %Main2D
@onready var win_screen = %WinScreen
@onready var lose_screen = %LoseScreen

var level_instance
var isOnMainMenu = true
var isPaused = false
var isSoulsFull = false
var currentlevel = 0
var player_default_health = 100.0
var player_health = 100.0
var isTutorialComplete = false
var isShowingCredits = false

func _ready():
	get_tree().paused = false
	hud.hide()
	win_screen.hide()
	lose_screen.hide()
	pause.hide()
	menu.show()
	%HealthBar.max_value = player_default_health
	%HealthBar.value = player_default_health
	%HealthBar.min_value = 0
	%Credits.hide()

func get_player_health():
	return player_health

func update_health(value: int):
	player_health = value
	%HealthBar.value = player_health
	if player_health <= 0:
		game_over()

func game_over():
	get_tree().paused = true
	lose_screen.show()

func game_won():
	get_tree().paused = true
	win_screen.show()
	load_music(7)
	
func finished_tutorial():
	isTutorialComplete = true
	start_over()
	
func start_over():
	lose_screen.hide()
	win_screen.hide()
	hud.show()
	pause.hide()
	menu.hide()
	%Credits.hide()
	isOnMainMenu = false
	isPaused = false
	isSoulsFull = false
	update_health(player_default_health)
	if isTutorialComplete:
		currentlevel = 1
		load_music(currentlevel)
		load_level("level1")
	else: 
		currentlevel = 0
		load_music(currentlevel)
		load_level("tutorial")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) and !isOnMainMenu:
		if isPaused: unpause_game()
		else: pause_game()
func stop_all_music():
	%MainMenuPlayer.stop()
	%TutorialPlayer.stop()
	%LevelOnePlayer.stop()
	%LevelTwoPlayer.stop()
	%LevelThreePlayer.stop()
	%LevelFourPlayer.stop()
	%LevelFivePlayer.stop()
	%LevelSixPlayer.stop()
	%WinScreenPlayer.stop()

func load_music(level: int):
	stop_all_music()
	if level == 0:
		%TutorialPlayer.play()
	elif level == 1:
		%LevelOnePlayer.play()
	elif level == 2: 
		%LevelTwoPlayer.play()
	elif level == 3: 
		%LevelThreePlayer.play()
	elif level == 4: 
		%LevelFourPlayer.play()
	elif level == 5: 
		%LevelFivePlayer.play()
	elif level == 6: 
		%LevelSixPlayer.play()
	elif level == 7: 
		%WinScreenPlayer.play()
	else: 
		%MainMenuPlayer.play()

func load_next_level(isLastLevel: bool = false):
	currentlevel += 1
	if !isLastLevel:
		unload_level()
		load_music(currentlevel)
		load_level("level%s" % str(currentlevel))
	else: 
		game_won()
	

func unload_level():
	if is_instance_valid(level_instance):
		level_instance.queue_free()
	level_instance = null
	hud.hide()
	menu.show()
	lose_screen.hide()
	win_screen.hide()
	isOnMainMenu = true

func load_level(level_name: String):
	unload_level()
	var level_path = "res://Levels/Scenes/%s.tscn" % level_name
	var level_resource = load(level_path)
	
	if level_resource:
		isOnMainMenu = false
		menu.hide()
		hud.show()
		level_instance = level_resource.instantiate()
		main_2d.call_deferred("add_child", level_instance)
		update_heart_label(0)
		get_tree().paused = false
		
func _on_play_button_pressed():
	start_over()

func pause_game():
	pause.show()
	isPaused = true
	get_tree().paused = true

func unpause_game():
	pause.hide()
	lose_screen.hide()
	win_screen.hide()
	%Credits.hide()
	isPaused = false
	get_tree().paused = false


func _on_resume_button_pressed():
	unpause_game()
	
func update_heart_label(amount:int):
	%HeartsLabel.text = str(amount)
	
func update_soul_progress(amount:int,max:int):
	%SoulsProgress.value = amount
	check_souls(amount,max)
func update_soul_progress_max(amount:int):
	%SoulsProgress.max_value = amount
func set_soul_progress():
	%SoulsProgress.min_value = 0
	%SoulsProgress.value = 0

func check_souls(collected:int,needed:int):
	if collected >= needed:
		isSoulsFull = true
	else: isSoulsFull = false
	%PressE.set_isshown(isSoulsFull)

func hide_heart_arrow_key():
	%PressE.hide()


func _on_play_again_pressed():
	# lose screen play again button
	start_over()


func _on_menu_pause_button_pressed():
	# pause menu main menu button
	load_music(8)
	unload_level()
	unpause_game()


func _on_options_pause_button_pressed():
	# pause menu options button
	pass


func _on_menu_win_button_pressed():
	# win screen main menu button
	load_music(8)
	unload_level()
	unpause_game()

func _on_menu_lose_button_pressed():
	# lose screen main menu button
	load_music(8)
	unload_level()
	unpause_game()

func _on_credits_button_pressed():
	%Credits.show()
