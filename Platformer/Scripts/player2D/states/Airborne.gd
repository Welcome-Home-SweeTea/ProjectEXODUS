extends PlayerState

func enter():
	pass

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()
	player.speed_vector.y += player.fall_acceleration * delta

	player.velocity = player.speed_vector
	player.move_and_slide()
	
	if player.is_on_floor():
		transitioned.emit(self, "idle")

func exit():
	pass
