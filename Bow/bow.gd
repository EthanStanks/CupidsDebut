extends Area2D

var isHeartArrowReady = false
var level
var isEnemies = false
var isArrowCooldownOver = true
var souls_needed

const NORMAL_ARROW = preload("res://Bow/arrow.tscn")
const HEART_ARROW = preload("res://Bow/love_arrow.tscn")

func _ready():
	level = get_parent().get_parent()
	souls_needed = level.get_souls_needed()

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)
		isEnemies = true
	else:
		isEnemies = false
		%BowSprite.play("Idle")
	
	if Input.is_action_pressed("heart_arrow"):
		heart_arrow()

func get_level():
	return level

func play_shoot_animation():
	if isArrowCooldownOver:
		isArrowCooldownOver = false
		%BowSprite.play("Shoot")
		await get_tree().create_timer(0.3).timeout
		shoot()
		isArrowCooldownOver = true

func shoot():
	if !isHeartArrowReady:
		var arrow = NORMAL_ARROW.instantiate()
		arrow.global_position = %ShootingPoint.global_position
		arrow.global_rotation = %ShootingPoint.global_rotation	
		%ShootingPoint.add_child(arrow)
		%ArrowSound.play()
		
	else:
		isHeartArrowReady = false
		var arrow = HEART_ARROW.instantiate()
		arrow.global_position = %ShootingPoint.global_position
		arrow.global_rotation = %ShootingPoint.global_rotation	
		%ShootingPoint.add_child(arrow)
		%LoveArrowSound.play()


func _on_start_animation_timer_timeout():
	if isEnemies: play_shoot_animation()

	
func heart_arrow():
	if level.get_souls_collected() >= souls_needed:
		level.hide_heart_arrow_key()
		isHeartArrowReady = true
		level.reset_souls()
	
