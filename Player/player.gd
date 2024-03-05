extends CharacterBody2D

signal health_depleted

var level

var SPEED
var health
var DAMAGE_RATE

var isKillAnimationPlaying = false

func _ready():
	level = get_parent()
	SPEED = level.get_player_speed()
	health = level.get_player_health()
	DAMAGE_RATE = level.get_enemy_damage()
	
func Animate():
	var head = %Head
	var legs = %Legs
	var torso = %Torso
	var deg = fmod(%Bow.rotation_degrees,360)
	if deg < 0: deg += 360
	var velocity_len = velocity.length()
	if %Bow.isEnemies:
		if deg >= 190 and velocity_len > 0.0:
			legs.play("WalkingBack")
			head.play("WalkingBack")
			torso.play("WalkingBack")
		elif deg >= 190 and velocity_len == 0.0:
			head.play("IdleBack")
			legs.play("IdleBack")
			torso.play("IdleBack")
		elif deg < 190 and velocity_len > 0.0:
			legs.play("WalkingFront")
			head.play("WalkingFront")
			torso.play("WalkingFront")
		elif deg < 190 and velocity_len == 0.0:
			head.play("IdleFront")
			legs.play("IdleFront")
			torso.play("IdleFront")
	else:
		%Bow.rotation_degrees = 90
		if  velocity_len > 0.0:
			legs.play("WalkingFront")
			head.play("WalkingFront")
			torso.play("WalkingFront")
		else:
			head.play("IdleFront")
			legs.play("IdleFront")
			torso.play("IdleFront")
	

func _physics_process(delta):
	if isKillAnimationPlaying:
		if !%Head.is_playing() and %Head.animation == "Died":
			level.update_player_health(health)
		print(%Head.is_playing(),%Head.animation)
	else:
		var direction = Input.get_vector("move_left","move_right","move_up","move_down")
		velocity = direction * SPEED
		move_and_slide()
		
		Animate()
		
		var overlapping_mobs = %HurtBox.get_overlapping_bodies()
		var overlapping_size = overlapping_mobs.size()
		if overlapping_size > 0:
			for enemy in overlapping_mobs:
				if enemy.has_method("touched_player"):
					health -= DAMAGE_RATE
					enemy.touched_player()
					if health <= 0:
						isKillAnimationPlaying = true
						%PlayerDiesSound.play()
						%Head.play("Died")
						%Torso.play("Died")
						%Diaper.play("Died")
						%Legs.play("Died")
					else:
						level.update_player_health(health)
						%PlayerHit.play()
						%Legs.modulate = Color.RED
						%Diaper.modulate = Color.RED
						%Torso.modulate = Color.RED
						%Head.modulate = Color.RED
						await get_tree().create_timer(0.1).timeout
						%Legs.modulate = Color.WHITE
						%Diaper.modulate = Color.WHITE
						%Torso.modulate = Color.WHITE
						%Head.modulate = Color.WHITE
		

func _on_heart_box_area_entered(area):
	if area.has_method("pickedup"):
		%HeartSound.play()
		area.pickedup()
		level.add_heart()

func isPlayer():
	return true
