extends Node2D

@onready var pot_plate_button: Button = $CanvasLayer/PotPlateButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pot_plate_button.pressed.connect(_on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/level1.tscn")
