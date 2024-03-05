extends Label

var isShown = false

@export var speed = 8

var time = 0
var sinTime = 0
var _visible = true

func set_isshown(value: bool):
	isShown = value

func flash_my_test():
	if sinTime > 0:
		_visible = true
	else:
		_visible = false
	
	visible = _visible

func _physics_process(delta):
	if isShown:
		time += delta
		sinTime = sin(time*speed)
		flash_my_test()
