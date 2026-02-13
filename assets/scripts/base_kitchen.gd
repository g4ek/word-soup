extends Node2D

@onready var pot_plate_button: Button = $CanvasLayer/PotPlateButton
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect

signal go_plate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pot_plate_button.pressed.connect(_on_button_pressed)
	self.hide()

func adjust_scale() -> void:
	var viewport_size = get_viewport_rect().size
	var texture_size = texture_rect.texture.get_size()
	
	var scale_x = viewport_size.x / texture_size.x
	var scale_y = viewport_size.y / texture_size.y
	
	texture_rect.scale = Vector2(scale_x, scale_y)
	
func _on_button_pressed() -> void:
	go_plate.emit()
