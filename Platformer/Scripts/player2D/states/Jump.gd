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
	default_input = ["7", "8", "9"]
	attack_type = "none"
	air_ok = false
	ground_ok = true

func enter():
	print(1)
	player.anim_player.play("jump")

func physics_process_state(delta: float) -> void:
	player.speed_vector = player.speed_vector.move_toward(
				Vector2.ZERO, player.running_acceleration * delta)
	player.velocity = player.speed_vector
	player.move_and_slide()

func exit():
	if (current_variation == "7"):
		player.speed_vector.x = -player.walk_speed
	if (current_variation == "8"):
		player.speed_vector.x = 0
	if (current_variation == "9"):
		player.speed_vector.x = player.walk_speed
	player.speed_vector.y = -player.jump_force
