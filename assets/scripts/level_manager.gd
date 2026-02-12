extends Node

# put all your levels here in the inspector
@export var levels : Array 
var level

@onready var main_menu: Control = $MainMenu


var num_level : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.start_level.connect(_on_start_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_level():
	# clears existing level
	if level != null:
		level.queue_free()
	level = levels[num_level].instantiate()
	self.add_child(level)
	num_level += 1

	
