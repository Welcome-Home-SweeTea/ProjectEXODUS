class_name Player
extends CharacterBody2D

@export var dummy : bool

@export var walk_speed = 12*100
@export var jump_force = 16*100
@export var speed = 0
@export var friction = 5*100
@export var fall_acceleration = 40*100
@export var running_acceleration = 60*100

@export var opponent : Player
@export var hitbox : Area2D
@export var hurtbox : Area2D
@export var collision_shape : CollisionShape2D
@export var collision_handler : Node
@export var hitspark_sprite : Sprite2D
@export var facing_direction = 1
@export var speed_vector = Vector2.ZERO
@export var anim_player : AnimationPlayer
@export var state_machine : Node

func _ready() -> void:
	#hitbox = get_node("Hitbox")
	#hurtbox = get_node("Hurtbox")
	#collision_shape = get_node("CollisionShape3D")
	#collision_handler = get_node("CollisionHandler")
	#anim_player = get_node("AnimationPlayer")
	#state_machine = get_node("PlayerStateMachine")
	state_machine.current_state.enter()

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	if (opponent != null and opponent.position.x < position.x):
		facing_direction = -1
	else:
		facing_direction = 1
	rotation = PI * (0.5 - 0.5 * facing_direction)
	scale = Vector2(1, facing_direction)
	#hitspark_sprite.position.z = 0.5 * facing_direction
			
func get_input_direction() -> Vector2:
	var running_direction = Vector2.ZERO

	if Input.is_action_pressed("Right"):
		running_direction.x += 1
	if Input.is_action_pressed("Left"):
		running_direction.x -= 1
	
	return running_direction

func set_speed_vector(new_speed_vector : Vector2):
	new_speed_vector.x *= facing_direction
	speed_vector = new_speed_vector*100

func add_speed_vector(new_speed_vector : Vector2):
	new_speed_vector.x *= facing_direction
	speed_vector += new_speed_vector*100
