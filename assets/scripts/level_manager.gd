extends Node

# put all your levels here in the inspector
@export var levels : Dictionary 
var level
var kitchen
var num_level : int = 0

@onready var main_menu: Control = $MainMenu
@onready var level_selection: Control = $LevelSelection


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.open_level_selection.connect(_on_open_level_selection)
	level_selection.level_selected.connect(_on_level_selected)
	level_selection.menu_button.connect(_on_menu_selected)
	
	main_menu.show()
	level_selection.hide()

func _on_open_level_selection():
	main_menu.hide()
	level_selection.show()
	
func _on_level_selected(index : int):
	if index >= levels.size():
		return
	
	level_selection.hide()
	num_level = index
	
	if level != null:
		level.queue_free()
		kitchen.queue_free()
	
	load_level(num_level)
	
func _on_menu_selected() -> void:
	if level != null:
		level.queue_free()
		level = null
	
	main_menu.show()
	level_selection.hide()

func _on_next_level() -> void:
	num_level += 1
	
	if level != null:
		level.queue_free()
		level = null
		
	if kitchen != null:
		kitchen.queue_free()
		kitchen = null
	
	if num_level >= levels.size():
		main_menu.show()
		level_selection.hide()
		num_level = 0
		return
	
	load_level(num_level)

func load_level(index : int):
	level = levels.keys()[index].instantiate()
	kitchen = levels.values()[index].instantiate()
	
	self.add_child(level)
	self.add_child(kitchen)
	
	if level.word:
		var clean_word = level.word.replace(" ", "")
		kitchen.scatter_letters(clean_word)
		print("level manager scattered the letters for " + clean_word)
	
	level.show()
	level.get_node("CanvasLayer").show()
	kitchen.hide()
	kitchen.get_node("CanvasLayer").hide()
	
	level.go_to_menu.connect(_on_menu_selected)
	level.next_level.connect(_on_next_level)
	level.go_kitchen.connect(_on_kitchen_button_press)
	kitchen.go_plate.connect(_on_plate_button_press)
	kitchen.get_node("CanvasLayer").get_node("Drawer").go_kitchen.connect(_on_kitchen_button_press)
	kitchen.get_node("CanvasLayer").get_node("Drawer").leave_kitchen.connect(_on_drawer_press)
	
func _on_kitchen_button_press() -> void:
	kitchen.show()
	kitchen.get_node("CanvasLayer").show()
	
	kitchen.get_node("CanvasLayer").get_node("PotPlateButton").show()
	kitchen.get_node("CanvasLayer").get_node("TextureRect").show()
	
	kitchen.set_containers_enabled(true)
	
	level.hide()
	level.get_node("CanvasLayer").hide()
	

func _on_plate_button_press() -> void:
	level.show()
	level.get_node("CanvasLayer").show()
	
	kitchen.hide()
	kitchen.get_node("CanvasLayer").hide()
	kitchen.set_containers_enabled(false)
	
func _on_drawer_press() -> void:
	kitchen.get_node("CanvasLayer").get_node("PotPlateButton").hide()
	kitchen.get_node("CanvasLayer").get_node("TextureRect").hide()
	kitchen.set_containers_enabled(false)
