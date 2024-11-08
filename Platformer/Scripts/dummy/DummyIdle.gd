extends PlayerState


func enter():
	player.anim_player.play("idle")

func process_state(delta: float):
	pass

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()
		
	player.speed = player.speed_vector.length()
	
	player.speed_vector = player.speed_vector.move_toward(
				Vector3.ZERO, player.running_acceleration * delta)
	player.speed_vector.y -= player.fall_acceleration * delta

	# Moving the Character
	player.velocity = player.speed_vector
	player.move_and_slide()
	
	#if !player.is_on_floor():
		#transitioned.emit(self, "airborne")

func exit():
	pass
