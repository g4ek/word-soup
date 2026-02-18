extends RigidBody2D

const SIMMER_SPEED : float = 400.0 # how fast you want the letters to move
var dragging = false
var in_pot = true
var in_drawer = false
var current_slot = null
@onready var soup_pot: StaticBody2D = get_tree().get_first_node_in_group("Pots")
@onready var letter_container : Node2D = soup_pot.get_node("LetterContainer")

@onready var default_letter: Sprite2D = $DefaultLetter
@onready var plate: Area2D = get_tree().get_first_node_in_group("Plates")


@export var character: String = "default":
	set(value):
		character = value.to_lower() # make sure it's always lowercase
		if is_node_ready():
			_update_visuals()


func _update_visuals():
	var path : String = "res://assets/sprites/Letters/" + character + "_letter.png"
	
	var tex = load(path)
	default_letter.texture = tex

func apply_simmer():
	var random_dir = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()
	
	apply_central_force(random_dir * SIMMER_SPEED)

func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var dist = global_position.distance_to(mouse_pos)
	return dist <= 30.0

func snap_to_slot(slot : Node2D):
	global_position = slot.global_position
	global_rotation = 0
	freeze = true
	in_pot = false
	
	slot.set_meta("occupied", true)
	slot.set_meta("letter_node", self)
	current_slot = slot
	
	plate.check_for_win()
	
func return_to_pot():
	var dist_to_pot = global_position.distance_to(soup_pot.global_position)
	var radius = soup_pot.get_node("DonutCollisionPolygon2D").radius
	
	if (dist_to_pot < radius):
		in_pot = true
		freeze = false
	else:
		# use a tween for smoot movement
		var tween = create_tween()
		
		tween.tween_property(self, "global_position", soup_pot.global_position,\
		0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		
		# when it comes back turn physics and simmering back on
		tween.finished.connect(func():
			in_pot = true
			freeze = false
		)
	
func check_snap() -> void:
	var closest_slot = null
	var shortest_dist = 80.0
	
	for slot in plate.get_node("SlotContainer").get_children():
		var dist = global_position.distance_to(slot.global_position)
		if dist < shortest_dist and slot.get_meta("occupied") == false:
			shortest_dist = dist
			closest_slot = slot
	
	if closest_slot:
		snap_to_slot(closest_slot)
	else:
		return_to_pot()
		closest_slot = null
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_visuals() 
	
	if in_drawer:
		freeze = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if in_drawer:
		freeze = true
		if is_mouse_over() and Input.is_action_just_pressed("select"):
			teleport_to_pot()
		return
	
	if dragging: # if the player is dragging
		# lock letter position to mouse
		global_position = get_global_mouse_position()
		
		# if the player lets go
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			dragging = false
			freeze = false # turns on physics
			check_snap() # whether/not it snaps to plate
			
	# if the player is NOT dragging
	else:
		# checks if player clicked the letter
		if is_mouse_over() and Input.is_action_just_pressed("select"):
			dragging = true
			freeze = true
			in_pot = false
			
			# if it was in a slot previously, that slot is now vacant
			if current_slot != null:
				# works b/c current_slot is a reference variable
				current_slot.set_meta("occupied", false)
				current_slot = null
			
	
	if in_pot:
		apply_simmer()

func teleport_to_pot() -> void:
	in_drawer = false
	in_pot = true
	
	self.reparent(letter_container)
	
	global_position = letter_container.global_position
	freeze = false
