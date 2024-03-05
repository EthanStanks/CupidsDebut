extends Area2D

var hearts_needed = 0
var level
var isComplete = false

func _ready():
	level = get_parent()
	hearts_needed = level.get_hearts_needed()
	%Sprite.play("default")
	
func unlock():
	isComplete = true
	%Sprite.play("unlocked")
	%WingSound.play()

func _on_body_entered(body):
	if body.has_method("isPlayer"):
		var hearts = level.get_hearts_collected()
		if hearts >= hearts_needed:
			level.level_passed()
		else: %Sprite.play("need")


func _on_body_exited(body):
	if !isComplete:
		%Sprite.play("default")
