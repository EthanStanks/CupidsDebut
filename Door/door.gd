extends Area2D

var hearts_needed = 0
var level

func _ready():
	level = get_parent()
	hearts_needed = level.get_hearts_needed()
	set_door()

func set_door():
	var sprite = %Sprite
	if hearts_needed == 2:
		sprite.play("2")
	elif hearts_needed == 5:
		sprite.play("5")
	elif hearts_needed == 10:
		sprite.play("10")
	elif hearts_needed == 15:
		sprite.play("15")
	elif hearts_needed == 20:
		sprite.play("20")
	else: sprite.play("1")

func _on_body_entered(body):
	if body.has_method("isPlayer"):
		var hearts = level.get_hearts_collected()
		if hearts >= hearts_needed:
			%DoorSound.play()
			level.level_passed()
		else: 
			%number.show()
			%number.play(str(hearts_needed))
			

func _on_body_exited(body):
	%number.hide()
