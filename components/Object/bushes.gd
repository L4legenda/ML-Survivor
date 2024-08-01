extends Area2D
class_name ObjectBushes

const APPLE = preload("res://components/Object/apple.tscn")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var radius: float = 30.0

func _on_timer_timeout() -> void:
	# Генерируем случайный угол
	var angle = randf() * TAU
	
	# Вычисляем координаты на окружности
	var x = radius * cos(angle)
	var y = radius * sin(angle)
	var position_on_circle = Vector2(x, y)
	
	# Спавним яблоко
	var apple_instance = APPLE.instantiate()
	add_child(apple_instance)
	apple_instance.position = position_on_circle
