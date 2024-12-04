extends PlayerState

func _ready():
	is_available = true
	is_cancelable = true
	is_normal_cancelable = true
	is_special_cancelable = true
	is_super_cancelable = true
	is_jump_cancelable = true
	is_crouch_cancelable = true
	cancel_options = []
	default_input = []
	attack_type = "none"
	air_ok = false
	ground_ok = true

func enter():
	player.anim_player.play("idle")

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()
		
	player.speed = player.speed_vector.length()
	if (!player.dummy and Input.is_action_pressed("Jump")):
		player.speed_vector = running_direction * player.walk_speed
		player.speed_vector.y = -player.jump_force
	
	player.speed_vector = player.speed_vector.move_toward(
				Vector2.ZERO, player.running_acceleration * delta)
	player.speed_vector.y += player.fall_acceleration * delta

	## Moving the Character
	#player.velocity = player.speed_vector
	#player.move_and_slide()
	
	if player.on_floor:
		if (!player.dummy and running_direction != Vector2.ZERO):
			transitioned.emit(self, "walk")
	else:
		transitioned.emit(self, "airborne")

func exit():
	pass
