extends CharacterBody2D


const max_Speed = 345
var accel = 210
var friction = 500
var movement = Vector2.ZERO
var onICE = false

func _process(delta):
	_playerMove(delta)

func _playerSpeed():
	movement.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	movement.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return movement.normalized()


func _playerMove(_delta):
	movement = _playerSpeed()
	
	if movement == Vector2.ZERO:
		if onICE != false:
			pass
			#Maybe use this bit for if we're on ICE later on?
#			if velocity.length() > (friction * delta):
#				velocity -= velocity.normalized() * (friction * delta)
#			else:
#				velocity = Vector2.ZERO
#				$AnimatedSprite2D.play("Idle")
		else: 
			velocity = Vector2.ZERO
			#$AnimatedSprite2D.play("Idle")
		
	else: 
		velocity += (movement * accel)
		velocity = velocity.limit_length(max_Speed)
		#$AnimatedSprite2D.play("Walk")
		#This if statement handles flipping directions of animation while walking
		#if movement.x > 0:
		#	$AnimatedSprite2D.scale.x = -1
		#elif movement.x < 0:
		#	$AnimatedSprite2D.scale.x = 1
	move_and_slide()
