extends CharacterBody2D


const WALK_SPEED = 820
const AIR_SPEED = 1200
const JUMP_VELOCITY = -2400
const FALL_VELOCITY = -5000

var doubleJump = true
var isAttacking = false
var isCrouching = false
var movementSpeed = WALK_SPEED

func _physics_process(delta: float) -> void:
	_activeHurtbox()
	#When in Air code
	if not is_on_floor():
		movementSpeed = AIR_SPEED
		if doubleJump != false && Input.is_action_just_pressed("Jump"):
			doubleJump = false
			velocity.y = JUMP_VELOCITY * 0.85
		else:
			velocity.y -= FALL_VELOCITY * delta
	else: #When on floor code:
		movementSpeed = WALK_SPEED
		doubleJump = true
		velocity = Vector2.ZERO
		if isAttacking != true:
			$AnimatedSprite2D.play("idle")

	# Handle Inputs:
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("Crouch") and is_on_floor():
		isCrouching = true
	else: 
		isCrouching = false
		_findInput()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction and isAttacking != true:
		velocity.x = direction * movementSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, movementSpeed)

	move_and_slide()

func _findInput():
	if not is_on_floor():
		pass #Direct to air attack buttons
	elif isCrouching != true:
		if Input.is_action_just_pressed("MagikButton"):
			pass
		elif Input.is_action_just_pressed("HevyAttack"):
			pass
		elif Input.is_action_just_pressed("medAttack"):
			pass
		elif Input.is_action_just_pressed("lightAttack"):
			isAttacking = true
			$AnimatedSprite2D.play("5a")
			_activateHitbox()
	elif isCrouching == true:
		if Input.is_action_just_pressed("lightAttack"):
			isAttacking = true
			_activateHitbox()

func _activeHurtbox():
	if isAttacking != false:
		if $AnimatedSprite2D.animation == "5a":
			#Headbox Movement
			$Hurtbox/CollisionHead2D.position.x = 90
			#Bodybox Movement
			$Hurtbox/CollisionBody2D.position.x = 15
			$Hurtbox/CollisionBody2D.scale.x = 1.1
			#Flankbox Movement
			$Hurtbox/CollisionFlank2D.position.x = -130
			$Hurtbox/CollisionFlank2D.scale.x = 1.1
	elif not is_on_floor():
		pass #Jumping Hurtboxes
	elif isCrouching != false:
		#Hurtboxes while crouching
		#Head
		$Hurtbox/CollisionHead2D.position.x = 135
		$Hurtbox/CollisionHead2D.position.y = -100
		#Body
		$Hurtbox/CollisionBody2D.position.x = 35
		$Hurtbox/CollisionBody2D.position.y = -70
		$Hurtbox/CollisionBody2D.scale.x = 1.8
		$Hurtbox/CollisionBody2D.scale.y = 0.5
		#Flank
		$Hurtbox/CollisionFlank2D.position.x = -145
		$Hurtbox/CollisionFlank2D.position.y = -45
		$Hurtbox/CollisionFlank2D.scale.x = 1.3
		$Hurtbox/CollisionFlank2D.scale.y = 0.4
	else: #Should Be in the Idle Phase
		_resetHurtbox()
		

func _activateHitbox():
	$Hitbox/CollisionShape2D.set_disabled(false)
	if $AnimatedSprite2D.animation == "5a":
		$Hitbox/CollisionShape2D.scale.x = 5
		$Hitbox/CollisionShape2D.scale.y = 1.5
		$Hitbox/CollisionShape2D.position.x = 180
		$Hitbox/CollisionShape2D.position.y = -75
#	elif $AnimatedSprite2D.animation == "idle":
#		$Hitbox/CollisionShape2D.scale.x = 1
#		$Hitbox/CollisionShape2D.scale.y = 0.3
#		$Hitbox/CollisionShape2D.position.x = 175
#		$Hitbox/CollisionShape2D.position.y = -35

func _resetHurtbox():
	#Head
	$Hurtbox/CollisionHead2D.position.x = 45
	$Hurtbox/CollisionHead2D.position.y = -330
	$Hurtbox/CollisionHead2D.scale.x = 1
	$Hurtbox/CollisionHead2D.scale.y = 1
	#Body
	$Hurtbox/CollisionBody2D.position.x = 0
	$Hurtbox/CollisionBody2D.position.y = -135
	$Hurtbox/CollisionBody2D.scale.x = 1
	$Hurtbox/CollisionBody2D.scale.y = 1
	#Flank
	$Hurtbox/CollisionFlank2D.position.x = -120
	$Hurtbox/CollisionFlank2D.position.y = -110
	$Hurtbox/CollisionFlank2D.scale.x = 1
	$Hurtbox/CollisionFlank2D.scale.y = 1

func _resetHitbox():
	$Hitbox/CollisionShape2D.set_disabled(true)
	$Hitbox/CollisionShape2D.scale.x = 1
	$Hitbox/CollisionShape2D.scale.y = 1
	$Hitbox/CollisionShape2D.position.x = 0
	$Hitbox/CollisionShape2D.position.y = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	isAttacking = false
	_resetHitbox()
	
