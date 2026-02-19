extends Area2D

var dragging = false

func _physics_process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging = false
	elif is_mouse_over() and Input.is_action_just_pressed("select"):
		dragging = true
		
func is_mouse_over() -> bool:
	var distance = global_position.distance_to(get_global_mouse_position())
	return distance < 30.0
