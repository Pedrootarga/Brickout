extends Node2D

@export var brick_scene: PackedScene
@export var min_size: float = 64
@export var max_size: float = 128
@export var num_bricks: int = 2

func _ready():
	if brick_scene:
		var screen_width = get_viewport_rect().size.x
		
		for i in range(num_bricks):
			var size = randf_range(min_size, max_size)
			var random_size = Vector2(size, size)
			var brick = brick_scene.instantiate()
			brick.set_scale(random_size / brick.get_child(0).get_texture().get_size()) 
			
			var pos_x = randf_range(random_size.x, screen_width - random_size.x)

			add_child(brick)
			brick.position = Vector2(pos_x, random_size.y/2) 
