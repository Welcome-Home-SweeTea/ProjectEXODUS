extends PlayerState

func _ready():
	is_available = true
	is_cancelable = true
	is_normal_cancelable = true
	is_special_cancelable = true
	is_super_cancelable = true
	is_jump_cancelable = false
	is_crouch_cancelable = false
	is_fall_cancelable = true
	cancel_options = []
	default_input = []
	attack_type = "none"
	air_ok = true
	ground_ok = false

func enter():
	pass

func physics_process_state(delta: float) -> void:
	var running_direction = player.get_input_direction()
	player.speed_vector.y += player.fall_acceleration * delta

	#player.velocity = player.speed_vector + player.push
	#player.move_and_slide()
	
	if player.on_floor:
		transitioned.emit(self, "idle")

func exit():
	pass
