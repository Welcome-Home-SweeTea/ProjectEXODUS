class_name CollisionResolver
extends Node

@export var characters : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(Engine.get_frames_per_second())  
	for character_path in characters:
		var character = get_node(character_path)
		# push
		if (character.push.x != 0):
			character.collision_mask += 0
		character.velocity += character.push
		character.opponent.velocity.x += character.opponent.push.x - attempt_movement(character, delta)
		attempt_movement(character.opponent, delta)
	for character_path in characters:
		var character = get_node(character_path)
		# speed_vector
		character.velocity += character.speed_vector
		
		if (character.push.x == 0):
			character.collision_mask += 1 << 1
			attempt_movement(character, delta)
			character.collision_mask -= 1 << 1
		else:
			exchange_velocity(character, character.opponent, delta)
		character.move_and_slide()
		character.velocity.y = 0.0
		character.on_floor = character.is_on_floor()
		
		
func exchange_velocity(char1: Player, char2: Player, delta: float) -> float:
	var total_movement = 0.0
	if (sign(char2.velocity.x) == sign(char1.velocity.x)
	and abs(char2.velocity.x) > abs(char1.velocity.x)):
		attempt_movement(char2, delta)
	else:
		char1.velocity.x = (char2.velocity.x + char1.velocity.x) / 2
		char2.velocity.x = char1.velocity.x
		if ((char1.velocity.x > 0 and char2.position.x > char1.position.x)
		or (char1.velocity.x < 0 and char2.position.x < char1.position.x)):
			char1.velocity.x = attempt_movement(char2, delta)
			total_movement += attempt_movement(char1, delta)
		else:
			char2.velocity.x = attempt_movement(char1, delta)
			total_movement += char2.velocity.x * delta
			attempt_movement(char2, delta)
	return total_movement

func attempt_movement(character: Player, delta: float) -> float:
	var total_movement = 0.0
	var vx = Vector2(character.velocity.x, 0.0)
	if character.velocity.x > 0:
		var a = 1
	var collision = character.move_and_collide(vx * delta)
	if collision:
		total_movement += collision.get_travel().x
		var collider = collision.get_collider()
		if collider.is_class("CharacterBody2D"):
			var vx2 = Vector2(collider.velocity.x, 0.0)
			vx = collision.get_remainder() / delta
			character.velocity.x = vx.x
			total_movement += exchange_velocity(character, collider, delta)
		if collider.is_class("StaticBody2D"):
			if (collision.get_normal().angle_to(-character.up_direction) > character.floor_max_angle):
				character.on_floor = true
			character.velocity.x = 0.0
		if (character.velocity.x > 0.08):
			attempt_movement(character, delta)
		
	character.velocity.x = 0.0
	if collision:
		return total_movement
	else:
		return vx.x * delta
	
func attempt_movement1(character: Player, delta: float) -> float:
	var a = character.velocity
	var collision = character.move_and_collide(character.velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if (collider.is_class("Player") and !collider.near_wall):
			a = character.velocity
			character.velocity = collision.get_remainder() / delta
			if (sign(collider.velocity.x) == sign(character.velocity.x)
			and abs(collider.velocity.x) > abs(character.velocity.x)):
				attempt_movement(collider, delta)
			else:
				character.velocity.x = (collider.velocity.x + character.velocity.x) / 2
				collider.velocity.x = character.velocity.x
				if ((character.velocity.x > 0 and collider.position.x > character.position.x)
				or (character.velocity.x < 0 and collider.position.x < character.position.x)):
					attempt_movement(collider, delta)
					attempt_movement(character, delta)
				else:
					attempt_movement(character, delta)
					attempt_movement(collider, delta)
		else:
			if (collision.get_normal().angle_to(-character.up_direction) > character.floor_max_angle):
				character.on_floor = true
			character.velocity = character.velocity.slide(collision.get_normal())
	else:
		character.velocity = Vector2.ZERO
		
	if (character.velocity.length() > 0.08):
		attempt_movement(character, delta)
	if (collision and collision.get_collider().is_class("CharacterBody2D")):
		return true
	return false
