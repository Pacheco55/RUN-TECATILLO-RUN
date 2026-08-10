extends CharacterBody2D


#const SPEED = 300.0
const JUMP_SPEED = -1500

# Get the gravity from the project settings to be synced with RigidBody nodes.
const gravity : int = 3000  #gravedad que afecta a salto


func _physics_process(delta):
	velocity.y += gravity * delta

	# Add the gravity.
	if is_on_floor():
		if not get_parent().game_runing:#estara en esta animacion hasta que el juego empiece por el .game_running:
			$AnimatedSprite2D.play("idle")#estara en esta animacion hasta que el juego empiece por el .game_running:
		else :
			$ColliRun.disabled = false
		# Handle jump.
			if Input.is_action_just_pressed("ui_accept") :
				velocity.y = JUMP_SPEED
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("agache")
				$Collijump.disabled = true
			else :
				$AnimatedSprite2D.play("run")
	else:
		#$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.play("jump")
		#$AudioStreamPlayer2D.play()

	move_and_slide()
