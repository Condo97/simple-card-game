class_name TouchManager extends Node2D
#
#signal left_mouse_button_click(raycast_results: Array[Dictionary])
#signal left_mouse_button_released(raycast_results: Array[Dictionary])
#
#static var instance: TouchManager
#
#func _ready() -> void:
	#instance = self
#
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == COLLISION_MASK_CARD:
		#if event.is_pressed():
			#left_mouse_button_click.emit(get_raycast_at_cursor_results())
		#else:
			#left_mouse_button_released.emit(get_raycast_at_cursor_results())
#
#func get_raycast_at_cursor_results() -> Array[Dictionary]:
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = get_global_mouse_position()
	#parameters.collide_with_areas = true
	#var results = space_state.intersect_point(parameters)
	#return results
