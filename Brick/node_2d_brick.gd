extends StaticBody2D

@export var spawn_time: float = 5.0
@export var min_size: float = 32
@export var max_size: float = 128

var can_spawn = true
var size
var main_scene

func _ready():
	print("Brick: _ready() called")
	$Timer.wait_time = spawn_time
	$Timer.start()
	print("Brick: Timer started")
	size = get_scale().x * get_node("Sprite2D").texture.get_size().x
	print("Brick: Size calculated: ", size)
	main_scene = get_parent()
	print("Brick: Main scene obtained: ", main_scene)

func _on_Timer_timeout():
	print("Brick: _on_Timer_timeout() called")
	if can_spawn:
		print("Brick: can_spawn is true")
		spawn_new_brick()
	else:
		print("Brick: can_spawn is false")

func spawn_new_brick():
	print("Brick: spawn_new_brick() called")
	var new_size = randf_range(min_size, max_size)
	var new_random_size = Vector2(new_size, new_size)
	print("Brick: New size generated: ", new_size)
	var new_brick = load("res://node_2d_brick.tscn").instantiate()
	print("Brick: New brick instantiated")
	new_brick.set_scale(new_random_size / new_brick.get_node("Sprite2D").texture.get_size())
	print("Brick: New brick scaled")

	var spawn_positions = get_free_spawn_positions(new_random_size.x)
	print("Brick: Spawn positions: ", spawn_positions.size())

	if spawn_positions.size() > 0:
		var random_spawn = spawn_positions[randi() % spawn_positions.size()]
		print("Brick: Random spawn position: ", random_spawn)
		new_brick.position = random_spawn
		main_scene.add_child(new_brick)
		print("Brick: New brick added to scene")
	else:
		can_spawn = false
		$Timer.stop()
		print("Brick: No spawn positions found, stopping timer")

func get_free_spawn_positions(new_size):
	print("Brick: get_free_spawn_positions() called")
	var positions = []
	var half_size = size / 2
	var new_half_size = new_size / 2
	var screen_size = get_viewport_rect().size

	# Verifica arestas (exemplo: superior e inferior)
	var top_pos = Vector2(position.x, position.y - half_size - new_half_size)
	var bottom_pos = Vector2(position.x, position.y + half_size + new_half_size)

	print("Brick: Checking top position: ", top_pos)
	if position.y - half_size - new_half_size > 0 and check_position(top_pos, new_size):
		print("Brick: Top position is valid")
		positions.append(top_pos)

	print("Brick: Checking bottom position: ", bottom_pos)
	if position.y + half_size + new_half_size < screen_size.y and check_position(bottom_pos, new_size):
		print("Brick: Bottom position is valid")
		positions.append(bottom_pos)

	#Adicionar verificação para esquerda e direita.

	print("Brick: Free spawn positions: ", positions.size())
	return positions

func check_position(pos, new_size):
	print("Brick: check_position() called for: ", pos)
	for child in main_scene.get_children():
		if child is StaticBody2D and child != self:
			var child_size = child.get_scale().x * child.get_node("Sprite2D").texture.get_size().x
			var collision_x = abs(pos.x - child.position.x) < (new_size / 2 + child_size / 2)
			var collision_y = abs(pos.y - child.position.y) < (new_size / 2 + size / 2)
			print("Brick: Checking child: ", child.name, " Collision X: ", collision_x, " Collision Y: ", collision_y)
			if collision_x and collision_y:
				print("Brick: Position is occupied")
				return false
	print("Brick: Position is free")
	return true

func _on_area_entered(area):
	print("Brick: _on_area_entered() called with: ", area.name)
	if area is StaticBody2D and area != self:
		var area_size = area.get_scale().x * area.get_node("Sprite2D").texture.get_size().x
		if size > area_size:
			print("Brick: Merging with smaller brick")
			size += area_size
			set_scale(Vector2(size / get_node("Sprite2D").texture.get_size().x, size / get_node("Sprite2D").texture.get_size().x))
			area.queue_free()
			can_spawn = true
			$Timer.start()
		else:
			print("Brick: Smaller brick merging with this brick")
			area._on_area_entered(self)
