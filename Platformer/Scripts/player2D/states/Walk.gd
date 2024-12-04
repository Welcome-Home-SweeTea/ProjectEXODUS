extends PlayerState

func _ready():
	is_available = true
	is_cancelable = true
	is_normal_cancelable = true
	is_special_cancelable = true
	is_super_cancelable = true
	is_jump_cancelable = true
	is_crouch_cancelable = true
	is_fall_cancelable = true
	cancel_options = []
	default_input = []
	attack_type = "none"
	air_ok = false
	ground_ok = true

func enter():
	player.anim_player.play("walk_f")

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()

	if player.on_floor:
		if running_direction != Vector2.ZERO:
			running_direction = running_direction.normalized()
			player.speed_vector = player.speed_vector.move_toward(
				running_direction * player.walk_speed, player.running_acceleration * delta)
		player.speed = player.speed_vector.length()
	
	#player.velocity = player.speed_vector + player.push
	#player.move_and_slide()
	
	if player.on_floor:
		if (!player.dummy and running_direction == Vector2.ZERO):
			transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")


func exit():
	pass
