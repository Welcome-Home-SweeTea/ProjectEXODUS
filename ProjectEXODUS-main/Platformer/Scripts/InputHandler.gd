extends Node

var input_history : Array = []
var input_history_max_size = 120
var input_buffer : Array = []
var input_buffer_max_size = 4

var button_names = ["A", "B", "C", "D"]

@export var registered_targets : Dictionary = {}
@export var player : Player
@export var damage : int
@export var blockstun : int
@export var hitstun : int
@export var hitspark : String

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if !player.dummy:
		var input_state = {
			"direction": 5,
			"buttons": [false, false, false, false],
		}	
		if Input.is_action_pressed("Right"):
			input_state.direction += 1
		if Input.is_action_pressed("Left"):
			input_state.direction -= 1
		if Input.is_action_pressed("Jump"):
			input_state.direction += 3
		if Input.is_action_pressed("Crouch"):
			input_state.direction -= 3
		input_state.buttons[0] = Input.is_action_pressed("lightAttack")
		input_state.buttons[1] = Input.is_action_pressed("medAttack")
		input_state.buttons[2] = Input.is_action_pressed("HevyAttack")
		
		input_history.push_front(input_state)
		if (input_history.size() > input_history_max_size):
			input_history.pop_back()
		
		var input_buffer_frame = []
		for i in range(4):
			if (input_history.size() > 1):
				if (input_history[0].buttons[i] > input_history[1].buttons[i]):
					input_buffer_frame.append(button_names[i])
					if (input_history[0].direction > 3):
						input_buffer_frame.append("5" + button_names[i])
					else:
						input_buffer_frame.append("2" + button_names[i])
				
		if (input_history[0].direction > 6):
			input_buffer_frame.append(str(input_history[0].direction))
		
		input_buffer.push_front(input_buffer_frame)
		if (input_buffer.size() > input_buffer_max_size):
			input_buffer.pop_back()
	
