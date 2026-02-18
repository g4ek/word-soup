extends Area2D

var letter_scene = preload("res://assets/scenes/letter.tscn")
signal container_requested(area)

func store_letter(char: String) -> void:
	var inst = letter_scene.instantiate()
	inst.character = char
	inst.in_container = true
	inst.in_pot = false
	
	print("Stored '" + char + "' in " + name)
	
	inst.hide()
	self.add_child(inst)
	
func clear_stored_letters():
	for child in self.get_children():
		if child is RigidBody2D:
			child.queue_free()

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		container_requested.emit(self)
