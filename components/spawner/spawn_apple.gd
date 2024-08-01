extends Node2D

const APPLE = preload("res://components/Object/apple.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var apple = APPLE.instantiate()
	apple.position = position
	add_child(apple)
