extends Node2D

var brick_scene = load("res://Brick/main_brick_scene.tscn")

func _on_timer_timeout() -> void:
	print(get_parent().get_parent().name,str($Area2DSpawner.get_overlapping_bodies()))
	if $Area2DSpawner.get_overlapping_bodies().size() < 1:
		var brick_instance = brick_scene.instantiate()
		brick_instance.global_transform = global_transform
		Globals.main_scene.add_child(brick_instance)
	print("-----------")
