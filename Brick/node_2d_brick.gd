extends StaticBody2D

@export var spawn_time: float = 3.0
@export var min_size: float = 8
@export var max_size: float = 128

var can_spawn = true
var size
var main_scene

func _ready():
	$Timer.wait_time = spawn_time
	$Timer.start()
	size = get_scale().x * get_node("Sprite2D").texture.get_size().x
	main_scene = get_tree().current_scene

func _on_timer_timeout():
	if can_spawn:
		spawn_new_brick()

func spawn_new_brick():
	var new_size = randf_range(min_size, max_size)
	var new_random_size = Vector2(new_size, new_size)
	var new_brick = load("res://Brick/node_2d_brick.tscn").instantiate()
	new_brick.set_scale(new_random_size / new_brick.get_node("Sprite2D").texture.get_size())

	var spawn_positions = get_free_spawn_positions(new_random_size.x)

	if spawn_positions.size() > 0:
		var random_spawn = spawn_positions[randi() % spawn_positions.size()]
		new_brick.position = random_spawn
		main_scene.get_node("Node2DBricks").add_child(new_brick)
	else:
		can_spawn = false
		$Timer.stop()

func get_free_spawn_positions(new_size):
	var positions = []
	var half_size = size / 2
	var new_half_size = new_size / 2
	var screen_size = get_viewport_rect().size

	# Verifica arestas
	var top_pos = Vector2(position.x, position.y - half_size - new_half_size)
	var bottom_pos = Vector2(position.x, position.y + half_size + new_half_size)
	var left_pos = Vector2(position.x - half_size - new_half_size, position.y)
	var right_pos = Vector2(position.x + half_size + new_half_size, position.y)

	if position.y - half_size - new_half_size > 0 and check_position(top_pos, new_size):
		positions.append(top_pos)

	if position.y + half_size + new_half_size < screen_size.y and check_position(bottom_pos, new_size):
		positions.append(bottom_pos)

	if position.x - half_size - new_half_size > 0 and check_position(left_pos, new_size):
		positions.append(left_pos)

	if position.x + half_size + new_half_size < screen_size.x and check_position(right_pos, new_size):
		positions.append(right_pos)

	return positions

func check_position(pos, new_size):
	var bricks_node = main_scene.get_node("Node2DBricks")
	for child in bricks_node.get_children():
		if child is StaticBody2D and child != self:
			var child_size = child.get_scale().x * child.get_node("Sprite2D").texture.get_size().x
			var collision_x = abs(pos.x - child.position.x) < (new_size / 2 + child_size / 2)
			var collision_y = abs(pos.y - child.position.y) < (new_size / 2 + size / 2)
			if collision_x and collision_y:
				return false
	return true

func _on_area_entered(area):
	if area is StaticBody2D and area != self:
		var area_size = area.get_scale().x * area.get_node("Sprite2D").texture.get_size().x
		if size > area_size:
			size += area_size
			set_scale(Vector2(size / get_node("Sprite2D").texture.get_size().x, size / get_node("Sprite2D").texture.get_size().x))
			area.queue_free()
			can_spawn = true
			$Timer.start()
		else:
			area._on_area_entered(self)
