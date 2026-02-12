extends Node2D

@onready var soup_pot: StaticBody2D = $SoupPot
@onready var plate: Area2D = $Plate
@onready var kitchen_button: Button = $CanvasLayer/KitchenButton

@onready var victory_label: Label = $CanvasLayer/VictoryLabel
@onready var main_menu_button: Button = $CanvasLayer/MainMenuButton
@onready var next_level_button: Button = $CanvasLayer/NextLevelButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plate.level_won.connect(_on_plate_level_won)
	kitchen_button.pressed.connect(_on_kitchen_button_pressed)
	main_menu_button.pressed.connect(_on_menu_button_pressed)
	next_level_button.pressed.connect(_on_menu_button_pressed)
	
	start_level("yogurt") 
	victory_label.visible = false
	kitchen_button.visible = false
	next_level_button.visible = false

func start_level(target_word : String):
	plate.build_word_slots(target_word)
	soup_pot.gen_letters_from_word(target_word)


func _on_plate_level_won() -> void:
	print("you won")
	$CanvasLayer/VictoryLabel.text = "You won!"
	victory_label.visible = true
	next_level_button.visible = true
	main_menu_button.visible = true
	
func _on_kitchen_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/base_kitchen.tscn")
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/ui/main_menu.tscn")
	
func _on_next_level_button_pressed() -> void:
	pass
