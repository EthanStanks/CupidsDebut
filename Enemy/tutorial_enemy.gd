extends CharacterBody2D

var level
var player
var health
var speed
var loved_speed
var player_damage

var isLoved = false
var hasFoundLove = false

var isKillAnimationPlaying = false

const HEART_DROP = preload("res://Drops/heart_drop.tscn")

func _ready():
	player = $"../Player"
	level = get_parent()
	health = level.get_enemy_health()
	speed = level.get_enemy_speed()
	loved_speed = level.get_loved_speed()
	player_damage = level.get_player_damage()
	
func Animate(facing: float):
	if isLoved:
		if facing > 0:
			%Sprite.play("LovedFrontWalking")
		else: %Sprite.play("LovedBackWalking")
	

func _physics_process(delta):
	if isKillAnimationPlaying:
		if !%Sprite.is_playing() and %Sprite.animation == "Died":
			destroy()
		elif !%Sprite.is_playing() and %Sprite.animation == "LovedDied":
			destroy()
	else:
		var facing = 1
		if isLoved:
			var enemies_needing_love = %LoverZone.get_overlapping_bodies()
			if enemies_needing_love.size() > 0:
				var target_lover = enemies_needing_love[0]
				var target_pos = target_lover.global_position
				var direction = global_position.direction_to(target_lover.global_position)
				facing = target_pos.y - global_position.y
				velocity = direction * speed
				move_and_slide()
		Animate(facing)
		

func arrow_touched():
	health -= player_damage
	%Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	%Sprite.modulate = Color.WHITE
	
	if health <= 0:
		level.add_soul()
		%EnemyDies.play()
		play_death_animation()

func destroy():
	queue_free()

func play_death_animation():
	if !isLoved:
		isKillAnimationPlaying = true
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, false)
		%Sprite.play("Died")
	else:
		isKillAnimationPlaying = true
		set_collision_layer_value(3, false)
		set_collision_mask_value(2, false)
		%Sprite.play("LovedDied")

func love_touched():
	play_death_animation()

func make_loved():
	isLoved = true
	speed = loved_speed
	set_collision_layer_value(2, false)
	set_collision_layer_value(3, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	set_collision_mask_value(4, true)
	set_collision_mask_value(5, true)
	
	%LoverZone.set_collision_mask_value(2, true) # target other enemies
	
	%LoverTouch.set_collision_mask_value(2, true) # touches enemy
	
func isDead():
	return isKillAnimationPlaying

func _on_lover_touch_body_entered(body):
	if isLoved and !hasFoundLove:
		hasFoundLove = true
		if body.has_method("love_touched"):
			if !body.isDead():
				body.love_touched()
				%LoverDies.play()
				play_death_animation()
				var heartdrop = HEART_DROP.instantiate()
				heartdrop.global_position = global_position
				heartdrop.z_index = -2
				get_parent().call_deferred("add_child", heartdrop)
			else: hasFoundLove = false
		else: hasFoundLove = false
