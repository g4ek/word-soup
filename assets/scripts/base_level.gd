extends Node2D

@onready var soup_pot: StaticBody2D = $SoupPot
@onready var plate: Area2D = $Plate

@onready var kitchen_button: Button = $CanvasLayer/KitchenButton

@onready var victory_label: Label = $CanvasLayer/VictoryLabel
@onready var main_menu_button: Button = $CanvasLayer/MainMenuButton
@onready var next_level_button: Button = $CanvasLayer/NextLevelButton
@onready var pause_overlay: ColorRect = $CanvasLayer/PauseOverlay


@export var word : String

signal go_to_menu
signal next_level
signal go_kitchen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	plate.level_won.connect(_on_plate_level_won)
	kitchen_button.pressed.connect(_on_kitchen_button_pressed)
	main_menu_button.pressed.connect(_on_menu_button_pressed)
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	
	start_level(word) 
	
	victory_label.hide()
	main_menu_button.hide()
	next_level_button.hide()
	pause_overlay.hide()

func start_level(target_word : String):
	plate.build_word_slots(target_word)
	
	# soup_pot.gen_letters_from_word(target_word)

func _on_plate_level_won() -> void:
	print("you won")
	victory_label.text = "You won!"
	
	victory_label.show()
	next_level_button.show()
	main_menu_button.show()
	
	victory_label.pivot_offset = victory_label.size / 2
	next_level_button.pivot_offset = next_level_button.size / 2
	main_menu_button.pivot_offset = main_menu_button.size / 2

	victory_label.scale = Vector2(0, 0)
	main_menu_button.scale = Vector2(0, 0)
	next_level_button.scale = Vector2(0, 0)
	
	var tween = create_tween()
	tween.tween_property(victory_label, "scale", Vector2(1, 1), \
	.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(main_menu_button, "scale", Vector2(1, 1), \
	.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(next_level_button, "scale", Vector2(1, 1), \
	.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func _on_kitchen_button_pressed() -> void:
	go_kitchen.emit()

	
func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	go_to_menu.emit()
	
func _on_next_level_button_pressed() -> void:
	next_level.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_resume_button_pressed() -> void:
	toggle_pause()
	
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	pause_overlay.visible = get_tree().paused
