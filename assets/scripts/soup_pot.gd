extends StaticBody2D

const LETTER = preload("uid://eptj8a16kcov")
@onready var letter_container: Node2D = $LetterContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func gen_letters_from_word(word : String):
	for child in letter_container.get_children():
		child.queue_free()
		
	for i in range(word.length()):
		# skip spaces
		if word[i] == " ": 
			continue
		
		var new_letter = LETTER.instantiate()
		letter_container.add_child(new_letter)
		new_letter.character = word[i]
		
		new_letter.position = Vector2(randf_range(-25.0, 25.0), randf_range(-25.0, 25.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
