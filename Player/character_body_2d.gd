extends CharacterBody2D


@export var speed : float = 300.0
@export var jump_force : float = -600.0
@export var jump_time : float = 0.25
@export var gravity_multiplier : float = 3.0
@onready var animated_sprite_2D:AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping : bool = false
var jump_timer : float = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_jumping:
		velocity.y += gravity * gravity_multiplier * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
	elif  Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_force
		
	if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time:
		jump_timer += delta
	else:
		is_jumping = false
		jump_timer = 0
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction !=0:
		animated_sprite_2D.flip_h = direction < 0
	
	handle_animations(direction)
	
	move_and_slide()

func handle_animations(direction : float) -> void:
	if abs(direction) > 0.1 and is_on_floor():
		animated_sprite_2D.play("running")
	elif not is_on_floor():
		animated_sprite_2D.play("jumping")
	else:
		animated_sprite_2D.play("idle")
