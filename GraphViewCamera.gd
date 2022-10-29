extends Camera2D

var panning = false
var panPoint = Vector2(0.0, 0.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if panning:
		self.position += panPoint - get_global_mouse_position()

func _input(event):
	if event.is_action_pressed("panCamera"):
		panning = true
		panPoint = get_global_mouse_position()
	if event.is_action_released("panCamera"):
		panning = false

	if event.is_action_pressed("zoomInCamera"):
		self.zoom *= 1.1
	if event.is_action_pressed("zoomOutCamera"):
		self.zoom *= 0.9
