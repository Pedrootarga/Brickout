extends Node2D

@export var brick_scene: PackedScene
@export var min_size: float = 32
@export var max_size: float = 128
@export var num_bricks: int = 3
@export var max_attempts = 10

var occupied_positions = []

func _ready():
	if brick_scene:
		var screen_width = get_viewport_rect().size.x
		
		for i in range(num_bricks):
			var size = randf_range(min_size, max_size)
			var random_size = Vector2(size, size)
			var brick = brick_scene.instantiate()
			brick.set_scale(random_size / brick.get_child(0).get_texture().get_size()) 
			
			var pos_x
			var attempts = 0
			var valid_position = false
			
			while attempts < max_attempts and not valid_position:
				pos_x = randf_range(random_size.x, screen_width - random_size.x)
				valid_position = true
				
				for occupied in occupied_positions:
					var occupied_x = occupied["position"]
					var occupied_size = occupied["size"]
					
					if abs(pos_x - occupied_x) < (random_size.x / 2 + occupied_size / 2):
						valid_position = false
						break
						
				attempts += 1
				
			if valid_position:
					occupied_positions.append({"position": pos_x, "size": random_size.x})
					add_child(brick)
					brick.position = Vector2(pos_x, random_size.y/2) 
