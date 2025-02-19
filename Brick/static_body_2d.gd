extends StaticBody2D

@export var size_range : Vector2 = Vector2(32, 128)
@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

var spawn_position : Vector2
var size : float

func _ready():
	size = randf_range(size_range.x, size_range.y)
	sprite.scale = Vector2(size / sprite.texture.get_width(), size / sprite.texture.get_height())
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.extents = Vector2(size / 2, size / 2)

	spawn_position = Vector2(randf_range(0, get_viewport().size.x), 0)
	position = spawn_position

func _process(delta):
	pass
