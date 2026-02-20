extends Node


@onready var menu_music = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(menu_music)
	menu_music.stream = preload("res://assets/audio/Word_Soup_Theme.ogg")
	menu_music.bus = "Music"

func play_menu_music() -> void:
	if not menu_music.playing:
		menu_music.play()
		menu_music.volume_db = -5
		
func stop_menu_music() -> void:
	if menu_music.playing:
		var tween = create_tween()
		tween.tween_property(menu_music, "volume_db", -80, 0.5)
		tween.finished.connect(func():
			menu_music.stop()
			menu_music.volume_db = 0
		)
