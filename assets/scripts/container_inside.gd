extends Node2D

@onready var letter_spawn_point: Marker2D = $LetterSpawnPoint
@onready var texture_rect: TextureRect = $TextureRect

@export var MARGIN : float = 100.0

var cabinet_x = 1152.0
var cabinet_y = 648.0

const INSIDE_CABINET = preload("uid://i0dqf6hd8hd3")
const INSIDE_DRAWER = preload("uid://cdbkqe5i76d1p")
const INSIDE_CABINET_WIDE = preload("uid://b2m0fripssguh")
const CLOSET = preload("uid://x5tx0fxilgtr")

signal go_kitchen
signal leave_kitchen

var junk_scaling_config = {
	"junk_paper": 7.0,
	"junk_wood_spatula": 7.0,
	"junk_mail": 6.0,
	"junk_rubber_band": 3.7,
	"junk_salt": 2.3,
	"junk_pepper": 2.3,
	"junk_screwdriver": 6.0,
	"junk_whisk": 5.5,
	"default": 2.5
}

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
	elif type.to_lower() == "closet":
		texture_rect.texture = CLOSET
		texture_rect.size.y = cabinet_x
	
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
	
	leave_kitchen.emit()
	
	for child in area.get_children():
		if child is RigidBody2D or child is Area2D:
			child.reparent(letter_spawn_point, false)
			child.scale = Vector2.ONE
			count += 1
			var size = texture_rect.size
			child.position = Vector2(
				randf_range(-size.x/2 + MARGIN, size.x/2 - MARGIN), 
				randf_range(-size.y/2 + MARGIN, size.y/2 - MARGIN)
			)
			
			
			if "in_container" in child:
				child.in_container = true
				child.freeze = true
				child.z_index = 1
				child.rotation = 0
				child.scale = (Vector2.ONE / letter_spawn_point.scale)
				
			if child.name.to_lower().contains("junk") or child is Area2D:
				child.rotation = randf_range(0, TAU)
				child.z_index = 2
				
				var base_mult = junk_scaling_config["default"]
				var sprite = child.get_node_or_null("Sprite2D")
				
				if sprite and sprite.texture:
					var tex_path = sprite.texture.resource_path.to_lower()
					
					for key in junk_scaling_config.keys():
						if key in tex_path:
							base_mult = junk_scaling_config[key]
							break
				
				child.scale = (Vector2.ONE / letter_spawn_point.scale) * base_mult
			child.show()
			
	print("Container opened. Moved " + str(count) + " letters to UI.")

# connected to the kitchen button
func close_container() -> void:
	if not self.visible:
		return
	
	if current_area:
		for child in letter_spawn_point.get_children():
			if child is RigidBody2D or child is Area2D:
				child.reparent(current_area)
				child.hide()
	self.hide()
	go_kitchen.emit()
