extends Node2D

@onready var letter_spawn_point: Marker2D = $LetterSpawnPoint
@onready var texture_rect: TextureRect = $TextureRect
@export var MARGIN : float = 100.0

var current_drawer_area : Area2D = null

func open_drawer(area : Node2D) -> void:
	current_drawer_area = area
	var count = 0
	var contents = area.get_children()
	
	for child in contents:
		if child is RigidBody2D:
			child.reparent(letter_spawn_point, false)
			child.show()
			
			count += 1
			var size = texture_rect.size
			child.global_position += Vector2(
				randf_range(-size.x/2 + MARGIN, size.x/2 - MARGIN), 
				randf_range(-size.y/2 + MARGIN, size.y/2 - MARGIN)
			)
			
	print("Drawer opened. Moved " + str(count) + " letters to UI.")

#func prepare_drawer(letters : Array[String]) -> void:
#	for child in letter_spawn_point.get_children():
#		child.queue_free()
#	
#	for char in letters:
#		var new_letter = letter_scene.instantiate()
#		
#		new_letter.character = char
#		new_letter.in_drawer = true
#		new_letter.in_pot = false
#		
#		letter_spawn_point.add_child(new_letter)
#		new_letter.position = Vector2(randf_range(-300.0, 300.0), randf_range(-100.0, 100.0))


func _on_kitchen_button_pressed() -> void:
	if current_drawer_area:
		for child in letter_spawn_point.get_children():
			child.reparent(current_drawer_area)
			child.hide()
	self.hide()
