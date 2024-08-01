extends CharacterBody2D

@onready var ai_controller_2d: Node2D = $AIController2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var detect_objects: Area2D = $DetectObjects
@onready var raycast_sensor_2d: RaycastSensor2D = $RaycastSensor2D

var speed := 100
var hungry := 100
var hungry_max := 100
var healpoint := 100
var healpoint_max := 100
var has_dead := false

var count_dead := 1

func _physics_process(delta: float) -> void:
	if ai_controller_2d.needs_reset:
		ai_controller_2d.reset()
		respawn()
	move(delta)
	
	move_and_slide()

func move(delta: float) -> void:
	velocity.x = ai_controller_2d.move.x * speed
	velocity.y = ai_controller_2d.move.y * speed
	
	if velocity.x or velocity.y:
		animated_sprite_2d.play("RUN")
	else:
		animated_sprite_2d.play("IDLE")
	animated_sprite_2d.flip_h = velocity.x < 0

func attackMe(dmg: int) -> void:
	var future_healpoint := healpoint - dmg
	if future_healpoint > 0:
		healpoint = future_healpoint
		ai_controller_2d.reward -= 0.3
	else:
		dead()

func dead():
	has_dead = true
	ai_controller_2d.reward -= 5.0 * count_dead
	count_dead += 1
	ai_controller_2d.reset()
	respawn()

func respawn():
	has_dead = false
	position = Vector2(-125, 3)
	healpoint = healpoint_max
	hungry = hungry_max

func hungring() -> void:
	var future_hungry := hungry - 1
	if hungry <= 0:
		attackMe(2)
	else:
		hungry = future_hungry

func eat_food(food: ObjectApple) -> void:
	ai_controller_2d.reward += 0.25
	food.queue_free()
	var future_hungry := hungry + 10
	if future_hungry > hungry_max:
		hungry = hungry_max
	else:
		hungry = future_hungry

func _on_detect_objects_area_entered(area: Area2D) -> void:
	if area is ObjectPoint:
		position = Vector2(-154, 3)
		ai_controller_2d.reward += 1.0
	if area is ObjectWallDead:
		dead()
	if area is ObjectApple:
		eat_food(area)

func _on_timer_sec_timeout() -> void:
	hungring()
