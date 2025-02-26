extends PlayerState

func _ready():
	is_available = true
	is_cancelable = false
	is_normal_cancelable = false
	is_special_cancelable = true
	is_super_cancelable = true
	is_jump_cancelable = false
	is_crouch_cancelable = false
	is_fall_cancelable = true
	cancel_options = []
	default_input = ["5A"]
	attack_type = "normal"
	air_ok = false
	ground_ok = true

func enter():
	player.anim_player.play("5A")
	player.speed_vector = Vector2.ZERO

func process_state(delta: float):
	pass

func physics_process_state(delta: float) -> void:
	player.speed_vector = player.speed_vector.move_toward(
				Vector2.ZERO, player.running_acceleration * delta)
	player.velocity = player.speed_vector
	player.move_and_slide()

func exit():
	pass
