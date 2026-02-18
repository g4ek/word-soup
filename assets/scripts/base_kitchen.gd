extends Node2D

@onready var pot_plate_button: Button = $CanvasLayer/PotPlateButton
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var drawer_areas: Node = $CanvasLayer/DrawerAreas
@onready var drawer: Node2D = $CanvasLayer/Drawer


signal go_plate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for area in drawer_areas.get_children():
		if area is Area2D:
			area.drawer_requested.connect(_on_drawer_requested)
			area.input_pickable = true
	
	drawer.hide()
	# self.hide()

func setup_kitchen_drawers(word : String) -> void:
	var letters = word.split("")
	var areas = drawer_areas.get_children()
	
	for a in areas:
		a.letter_to_spawn = ""
	
	for i in range(letters.size()):
		if i < areas.size():
			areas[i].letter_to_spawn = letters[i]

func scatter_letters(word : String) -> void:
	var areas = drawer_areas.get_children()
	
	for area in areas:
		if area is Area2D:
			area.clear_stored_letters()
			
	for character in word:
		var random_drawer = areas.pick_random()
		random_drawer.store_letter(character)

func _on_drawer_requested(area : Area2D) -> void:
	if drawer.visible:
		return
	
	# drawer.prepare_drawer(letters)
	drawer.open_drawer(area)
	drawer.show()
	print("drawer activated")

func adjust_scale() -> void:
	var viewport_size = get_viewport_rect().size
	var texture_size = texture_rect.texture.get_size()
	
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	
	texture_rect.scale = Vector2(scale_x, scale_y)

func _on_pot_plate_button_pressed() -> void:
	go_plate.emit()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		go_plate.emit()
