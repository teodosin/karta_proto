extends Camera2D

var panning = false
var panPoint = Vector2(0.0, 0.0)

var nextPosition = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if nextPosition != null:
		var difference = nextPosition - self.position
		if difference.length() > 0.1:
			self.set_position(self.position + difference / 2)
		else: 
			nextPosition = null
	
	if panning:
		self.position += panPoint - get_global_mouse_position()

func animatePosition(newPosition):
	nextPosition = newPosition

func _input(event):
	if event.is_action_pressed("panCamera"):
		panning = true
		panPoint = get_global_mouse_position()
	if event.is_action_released("panCamera"):
		panning = false

	if event.is_action_pressed("zoomInCamera"):
		var adjustedPosition = (get_global_mouse_position() - self.position) * 0.1
		self.position = self.position + adjustedPosition
		self.zoom *= 1.1
	if event.is_action_pressed("zoomOutCamera"):
		if zoom.x <= 0.2:
			return
			
		self.zoom *= 0.9
