extends Node2D

@onready var letter_spawn_point: Marker2D = $LetterSpawnPoint
@onready var texture_rect: TextureRect = $TextureRect
@export var MARGIN : float = 100.0

var cabinet_x = 576.0 * 2
var cabinet_y = 324.0 * 2

const INSIDE_CABINET = preload("uid://i0dqf6hd8hd3")
const INSIDE_DRAWER = preload("uid://cdbkqe5i76d1p")
const INSIDE_CABINET_WIDE = preload("uid://b2m0fripssguh")


var current_area : Area2D = null

func open_container(area : Node2D, type: String) -> void:
	current_area = area
	var count = 0

	# clear the old levels from prev. opening
	for child in letter_spawn_point.get_children():
		child.free()
	
	if type.to_lower() == "cabinet":
		texture_rect.texture = INSIDE_CABINET_WIDE
		texture_rect.size.y = cabinet_x
	elif type.to_lower() == "drawer":
		texture_rect.texture = INSIDE_DRAWER
		texture_rect.size = Vector2(cabinet_x, cabinet_y)
	
	texture_rect.scale = Vector2.ONE
	
	texture_rect.pivot_offset = texture_rect.size / 2
	texture_rect.position = get_viewport_rect().size / 2 - texture_rect.pivot_offset
	
	letter_spawn_point.position = texture_rect.position + texture_rect.size / 2
	
	var screen_size = get_viewport_rect().size
	var scale_factor = min(
		screen_size.x / texture_rect.size.x,
		screen_size.y / texture_rect.size.y
	)
	texture_rect.scale = Vector2(scale_factor, scale_factor)
	letter_spawn_point.scale = texture_rect.scale
	
	for child in area.get_children():
		if child is RigidBody2D:
			child.reparent(letter_spawn_point, false)
			
			count += 1
			var size = texture_rect.size
			child.position = Vector2(
				randf_range(-size.x/2 + MARGIN, size.x/2 - MARGIN), 
				randf_range(-size.y/2 + MARGIN, size.y/2 - MARGIN)
			)
			
			child.show()
			child.in_container = true
			child.freeze = true
			child.scale = Vector2.ONE
			
	print("Container opened. Moved " + str(count) + " letters to UI.")

#func prepare_container(letters : Array[String]) -> void:
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

# connected to the kitchen button
func close_container() -> void:
	if not self.visible:
		return
	
	if current_area:
		for child in letter_spawn_point.get_children():
			if child is RigidBody2D:
				child.reparent(current_area)
				child.hide()
	self.hide()
