extends Area2D

@onready var slot_container: Node2D = $SlotContainer

@export var slot_scene: PackedScene = preload("uid://cpmbjav7tg2et")
@export var spacing : float = 30.0
@export var line_height : float = 45.0
@export var y_bias : float = -40.0

signal level_won

func build_word_slots(word : String):
	# clear existing slots
	for child in slot_container.get_children():
		child.queue_free()
		
	var words = word.split(" ")
	var current_line = 0
	
	for w in words:
		var start_x = -(w.length() - 1) * spacing / 2.0
		
		for i in range(w.length()):
			var new_slot = slot_scene.instantiate()
			slot_container.add_child(new_slot)
			
			var x_pos = start_x + i * spacing
			var y_pos = y_bias + (current_line * line_height)
			
			new_slot.position = Vector2(x_pos, y_pos)
			
			new_slot.set_meta("expected_char", w[i].to_lower())
			new_slot.set_meta("occupied", false)
			
		current_line += 1

func check_for_win() -> void:
	var slots = slot_container.get_children()
	var count = 0
	
	for slot in slots:
		if not slot.get_meta("occupied"): 
			return
		
		var letter_node = slot.get_meta("letter_node")
		var expected_char = slot.get_meta("expected_char")
		
		if letter_node.character == expected_char:
			count += 1
			
	if count == slots.size():
		victory()
			
			
func victory():
	level_won.emit()
