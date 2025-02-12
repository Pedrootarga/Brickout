extends RigidBody2D

func _process(delta: float) -> void:
	var direction : float = 0.0
	if Input.is_action_pressed("left"):
		direction = direction - 1.0
	if Input.is_action_pressed("right"):
		direction = direction + 1.0
	apply_central_impulse(15*Vector2(direction,0))
	if direction != 0:
		if direction < 0 and $Sprite2DPlayer.scale.x > 0:
			$Sprite2DPlayer.scale.x = -1.5
		if direction > 0 and $Sprite2DPlayer.scale.x < 0:
			$Sprite2DPlayer.scale.x = 1.5
