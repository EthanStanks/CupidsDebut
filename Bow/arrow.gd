extends Area2D

var hasHitEnemy = false
var travelled_distance = 0

var SPEED
var RANGE

func _ready():
	var level = get_parent().get_parent().get_parent().get_level() # uhhhhh
	SPEED = level.get_arrow_speed()
	RANGE = level.get_arrow_range()

func _physics_process(delta):
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	if !hasHitEnemy:
		hasHitEnemy = true
		queue_free()
		if body.has_method("arrow_touched"):
			body.arrow_touched()
