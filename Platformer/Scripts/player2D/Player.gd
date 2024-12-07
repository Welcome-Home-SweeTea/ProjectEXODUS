class_name Player
extends CharacterBody2D

@export var dummy : bool

@export var walk_speed = 12*100
@export var jump_force = 16*100
@export var speed = 0
@export var push = Vector2(0, 0)
@export var friction = 5*100
@export var fall_acceleration = 40*100
@export var running_acceleration = 60*100
@export var unstuck_speed = 3

@export var opponent : Player
@export var hitbox : Area2D
@export var hurtbox : Area2D
@export var collision_shape : CollisionShape2D
@export var collision_handler : Node
@export var hitspark_sprite : Sprite2D
@export var facing_direction = 1
@export var on_floor = false
@export var near_wall = false
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
	for state in state_machine.get_children():
		state.player = self
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
	
	# get velocity
	state_machine.physics_process(delta)
	#velocity = speed_vector
	
	# get extra unstuck push force
	push.x = 0
	var eps = 0
	var my_col_box = get_collision_borders()
	var opp_col_box = opponent.get_collision_borders()
	if (opp_col_box.l < my_col_box.r and my_col_box.l < opp_col_box.r
	and opp_col_box.u < my_col_box.b and my_col_box.u < opp_col_box.b):
		exchange_velocity(opponent)
		if (opponent.position.x > position.x):
			push.x = -min(my_col_box.r - opp_col_box.l + eps, unstuck_speed) / delta
			#push.x = -float(my_col_box.r - opp_col_box.l) / delta
		else:
			push.x = min(opp_col_box.r - my_col_box.l + eps, unstuck_speed) / delta
			#push.x = float(opp_col_box.r - my_col_box.l) / delta
	else:
		push.x = 0
	#velocity += push 
	
	
	#move_and_collide(velocity)
	
			
func get_input_direction() -> Vector2:
	var running_direction = Vector2.ZERO

	if Input.is_action_pressed("Right"):
		running_direction.x += 1
	if Input.is_action_pressed("Left"):
		running_direction.x -= 1
	
	return running_direction
	
func get_collision_borders() -> Dictionary:
	var collision_box = {
		'l' = position.x + collision_shape.position.x * facing_direction - collision_shape.shape.size.x / 2,
		'r' = position.x + collision_shape.position.x * facing_direction + collision_shape.shape.size.x / 2,
		'u' = position.y + collision_shape.position.y - collision_shape.shape.size.y / 2,
		'b' = position.y + collision_shape.position.y + collision_shape.shape.size.y / 2,
	}	
	return collision_box
	
func exchange_velocity(entity: Player):
	if entity.near_wall:
		velocity.x = 0.0
	else:
		velocity.x = (entity.velocity.x + velocity.x) / 2
		entity.velocity.x = velocity.x

func set_speed_vector(new_speed_vector : Vector2):
	new_speed_vector.x *= facing_direction
	speed_vector = new_speed_vector*100

func add_speed_vector(new_speed_vector : Vector2):
	new_speed_vector.x *= facing_direction
	speed_vector += new_speed_vector*100
