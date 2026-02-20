extends Control

signal open_level_selection
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManager.play_menu_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_button_pressed() -> void:
	open_level_selection.emit()
