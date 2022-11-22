extends Camera2D

var panning = false
var panPoint = Vector2(0.0, 0.0)




func _physics_process(_delta):
	
	if panning:
		self.position += panPoint - get_global_mouse_position()

func animatePosition(newPosition):
	pass
	

func _input(event):
	if event.is_action_pressed("panCamera"):
		panning = true
		panPoint = get_global_mouse_position()
	if event.is_action_released("panCamera"):
		panning = false

	if event.is_action_pressed("zoomInCamera"):

		setZoom(1.1, true)
	if event.is_action_pressed("zoomOutCamera"):
		if zoom.x <= 0.2:
			return
			
		setZoom(0.9, false)

func setZoom(mult: float, toMouse: bool):
	
	self.zoom *= mult

	if toMouse:
				# Zoom is centered on mouse position
		var adjustedPosition = (get_global_mouse_position() - self.position) * 0.1
		self.position = self.position + adjustedPosition
