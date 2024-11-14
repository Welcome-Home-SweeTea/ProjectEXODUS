class_name PlayerState
extends State

@export var player : Node

@export var is_available : bool = true
@export var is_cancelable : bool

@export var is_normal_cancelable : bool = true
@export var is_special_cancelable : bool = true
@export var is_super_cancelable : bool = true
@export var is_jump_cancelable : bool
@export var is_crouch_cancelable : bool
@export var is_fall_cancelable : bool
@export var cancel_options : Array
@export var default_input : Array
@export var attack_type : String
@export var air_ok : bool
@export var ground_ok : bool

@export var current_variation : String

func _ready() -> void:
	player = owner
	assert(player != null)

func back_to_idle() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")

func switch_to_state(state: String) -> void:
	transitioned.emit(self, state)
