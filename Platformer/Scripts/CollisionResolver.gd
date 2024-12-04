class_name CollisionResolver
extends Node

@export var characters : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	for character_path in characters:
		var character = get_node(character_path)
		if (character.push.x == 0):
			character.collision_mask += 1 << 1
			attempt_movement(character, delta)
			character.collision_mask -= 1 << 1
		else:
			attempt_movement(character, delta)
		character.move_and_slide()
		character.on_floor = character.is_on_floor()

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
			if (sign(vx2.x) == sign(vx.x)
			and abs(vx2.x) > abs(vx.x)):
				attempt_movement(collider, delta)
			else:
				character.velocity.x = (vx2.x + vx.x) / 2
				collider.velocity.x = character.velocity.x
				if ((character.velocity.x > 0 and collider.position.x > character.position.x)
				or (character.velocity.x < 0 and collider.position.x < character.position.x)):
					character.velocity.x = attempt_movement(collider, delta)
					total_movement += attempt_movement(character, delta)
				else:
					collider.velocity.x = attempt_movement(character, delta)
					total_movement += collider.velocity.x
					attempt_movement(collider, delta)
		if collider.is_class("StaticBody2D"):
			if (collision.get_normal().angle_to(-character.up_direction) > character.floor_max_angle):
				character.on_floor = true
			vx = Vector2.ZERO
		if (vx.length() > 0.08):
			attempt_movement(character, delta)
	else:
		vx = Vector2.ZERO
		
	character.velocity.x = 0.0
	if collision:
		if total_movement == 0:
			character.near_wall = true
		return total_movement / delta
	else:
		character.near_wall = true
		return vx.x
	
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
