extends PlayerState


func enter():
	player.speed_vector = Vector2.ZERO
	player.anim_player.play("pilebunker")

func process_state(delta: float):
	pass

func physics_process_state(delta: float) -> void:
	player.speed_vector = player.speed_vector.move_toward(
				Vector2.ZERO, player.running_acceleration * delta)
	player.velocity = player.speed_vector
	player.move_and_slide()
	
	if is_cancelable:
		if (!player.dummy and Input.is_action_pressed("lightAttack")):
			transitioned.emit(self, "5A")
		if (!player.dummy and Input.is_action_pressed("HevyAttack")):
			transitioned.emit(self, "Pilebunker")

func exit():
	pass
