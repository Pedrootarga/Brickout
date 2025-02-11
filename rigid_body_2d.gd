extends RigidBody2D

func _process(delta: float) -> void:
	var direction : float = 0.0
	if Input.is_action_pressed("left"):
		direction = direction - 1.0
	if Input.is_action_pressed("right"):
		direction = direction + 1.0
	apply_central_impulse(Vector2(direction,0))
