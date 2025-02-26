class_name Player3D
extends CharacterBody3D

@export var dummy : bool

@export var walk_speed = 12
@export var jump_force = 16
@export var speed = 0
@export var friction = 5
@export var fall_acceleration = 40
@export var running_acceleration = 60

@export var opponent : Player3D
@export var hitbox : Area3D
@export var hurtbox : Area3D
@export var collision_shape : CollisionShape3D
@export var collision_handler : Node
@export var hitspark_sprite : Sprite3D
@export var facing_direction = 1
@export var speed_vector = Vector3.ZERO
@export var anim_player : AnimationPlayer
@export var state_machine : Node

func _ready() -> void:
	hitbox = get_node("Hitbox")
	hurtbox = get_node("Hurtbox")
	collision_shape = get_node("CollisionShape3D")
	collision_handler = get_node("CollisionHandler")
	#anim_player = get_node("AnimationPlayer")
	state_machine = get_node("PlayerStateMachine")
	state_machine.current_state.enter()

func _physics_process(delta):
	var space_state = get_world_3d().direct_space_state
	if (opponent != null and opponent.position.x < position.x):
		facing_direction = -1
	else:
		facing_direction = 1
	rotation = Vector3(0, 0, PI * (0.5 - 0.5 * facing_direction))
	scale = Vector3(1, facing_direction, facing_direction)
	position.z = 0
	hitspark_sprite.position.z = 0.5 * facing_direction
			
func get_input_direction() -> Vector3:
	var running_direction = Vector3.ZERO

	if Input.is_action_pressed("Right"):
		running_direction.x += 1
	if Input.is_action_pressed("Left"):
		running_direction.x -= 1
	
	return running_direction

func set_speed_vector(new_speed_vector : Vector3):
	new_speed_vector.x *= facing_direction
	speed_vector = new_speed_vector

func add_speed_vector(new_speed_vector : Vector3):
	new_speed_vector.x *= facing_direction
	speed_vector += new_speed_vector
