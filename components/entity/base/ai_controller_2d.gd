extends AIController2D

var move := Vector2.ZERO
@onready var raycast_sensor_2d: RaycastSensor2D = $"../RaycastSensor2D"

func get_obs() -> Dictionary:
	var obs := [
		owner.position.x,
		owner.position.y,
		owner.hungry,
		owner.healpoint,
		owner.has_dead,
	]
	for r in calculate_raycasts():
		obs.append(r)
	return {"obs": obs}

func get_reward() -> float:
	return reward
	
func get_action_space() -> Dictionary: 
	return {
		"move" : {
			"size": 2,
			"action_type": "continuous"
		},
		}
	
func set_action(action) -> void:
	move.x = action["move"][0]
	move.y = action["move"][1]
# -----------------------------------------------------------------------------#

func calculate_raycasts() -> Array:
	var result = []
	for ray in raycast_sensor_2d.get_children():
		ray.enabled = true
		ray.force_raycast_update()
		var distance = _get_raycast_distance(ray)
		var index_object = _get_raycast_object(ray)
		result.append(distance)
		result.append(index_object)
		ray.enabled = false
	return result


func _get_raycast_distance(ray: RayCast2D) -> float:
	if !ray.is_colliding():
		return 0.0

	var distance = (global_position - ray.get_collision_point()).length()
	distance = clamp(distance, 0.0, raycast_sensor_2d.ray_length)
	return (raycast_sensor_2d.ray_length - distance) / raycast_sensor_2d.ray_length

func _get_raycast_object(ray: RayCast2D) -> int:
	if !ray.is_colliding():
		return 0
	var colliding := ray.get_collider()
	if colliding is ObjectApple:
		return 1
	elif colliding is ObjectBushes:
		return 2
	elif colliding is ObjectWallDead:
		return 3
	return 0
	
