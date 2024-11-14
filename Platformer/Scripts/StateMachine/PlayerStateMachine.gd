class_name PlayerStateMachine
extends Node

@export var initial_state : PlayerState
@export var input_handler : Node
var current_state : PlayerState
var states : Dictionary = {}
var input_to_states : Dictionary = {}

var normals = []
var specials = []
var supers = []

func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			print(child.default_input)
			for input in child.default_input:
				if !input_to_states.has(input):
					input_to_states[input] = []
				input_to_states[input].append(child)
			# making cancel option lists for special- and super-cancelable moves
			if (child.attack_type == "normal"):
				normals.append(child.name.to_lower())
			if (child.attack_type == "special"):
				specials.append(child.name.to_lower())
			if (child.attack_type == "super"):
				supers.append(child.name.to_lower())
	# filling cancel option lists for moves
	for state in states.values():
		if state.is_jump_cancelable:
			state.cancel_options.append("jump")
		if state.is_normal_cancelable:
			state.cancel_options.append_array(normals)
		if state.is_special_cancelable:
			state.cancel_options.append_array(specials)
		if state.is_super_cancelable:
			state.cancel_options.append_array(supers)		
		
	initial_state = get_child(0)
	if initial_state:
		current_state = initial_state


func _process(delta):
	if current_state:
		current_state.process_state(delta)


func _physics_process(delta):
	# going through moves that can activate by given input, pick first available
	# [TODO: add move priority check]
	var next_state
	var used_input
	for input_frame in input_handler.input_buffer:
		for input in input_frame:
			if input_to_states.has(input):
				for state in input_to_states[input]:
					if !next_state:
						# [TODO: rewrite this in better way]
						var cancel_is_valid = true
						if !(current_state.cancel_options.has(state.name.to_lower())
						 and state.is_available):
							cancel_is_valid = false
						if (!state.ground_ok and state.player.is_on_floor()):
							cancel_is_valid = false
						if (!state.air_ok and !state.player.is_on_floor()):
							cancel_is_valid = false
						if cancel_is_valid:
							next_state = state
							used_input = input
	if (next_state and next_state != current_state):
		on_child_transition(current_state, next_state.name.to_lower(), used_input)
	
	if current_state:
		current_state.physics_process_state(delta)


func on_child_transition(state: PlayerState, new_state_name: String, input: String = ""):
	# Doesn't allow state to cancel into itself
	#if state != current_state:
		#return
	
	# Make sure state exists
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Clean up the previous state
	if current_state:
		current_state.exit()
	
	# Intialize the new state
	new_state.current_variation = input
	new_state.enter()
	current_state = new_state
