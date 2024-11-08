extends PlayerState


func enter():
	player.anim_player.play("idle")

func process_state(delta: float):
	pass

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()
		
	player.speed = player.speed_vector.length()
	if (!player.dummy and Input.is_action_pressed("Jump")):
		player.speed_vector = running_direction * player.walk_speed
		player.speed_vector.y = player.jump_force
	
	player.speed_vector = player.speed_vector.move_toward(
				Vector3.ZERO, player.running_acceleration * delta)
	player.speed_vector.y -= player.fall_acceleration * delta

	# Moving the Character
	player.velocity = player.speed_vector
	player.move_and_slide()
	
	if player.is_on_floor():
		if (!player.dummy and Input.is_action_pressed("lightAttack")):
			transitioned.emit(self, "5A")
		if (!player.dummy and Input.is_action_pressed("HevyAttack")):
			transitioned.emit(self, "Pilebunker")
		if (!player.dummy and running_direction != Vector3.ZERO):
			transitioned.emit(self, "walk")
	else:
		transitioned.emit(self, "airborne")

func exit():
	pass
