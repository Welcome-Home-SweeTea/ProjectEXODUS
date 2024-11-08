class_name PlayerState
extends State

@export var player : Node
@export var is_cancelable : bool
@export var cancel_options : ItemList

func _ready() -> void:
	player = owner
	assert(player != null)

func back_to_idle() -> void:
	if player.is_on_floor():
		transitioned.emit(self, "idle")
	else:
		transitioned.emit(self, "airborne")
