extends Control

signal level_selected(index : int)
signal menu_button

func _on_l_1_button_pressed() -> void:
	level_selected.emit(0)

func _on_l_2_button_pressed() -> void:
	level_selected.emit(1)

func _on_l_3_button_pressed() -> void:
	level_selected.emit(2)

func _on_l_4_button_pressed() -> void:
	level_selected.emit(3)

func _on_l_5_button_pressed() -> void:
	level_selected.emit(4)

func _on_l_6_button_pressed() -> void:
	level_selected.emit(5)

func _on_l_7_button_pressed() -> void:
	level_selected.emit(6)

func _on_l_8_button_pressed() -> void:
	level_selected.emit(7)

func _on_l_9_button_pressed() -> void:
	level_selected.emit(8)

func _on_l_10_button_pressed() -> void:
	level_selected.emit(9)

func _on_menu_button_pressed() -> void:
	menu_button.emit()
