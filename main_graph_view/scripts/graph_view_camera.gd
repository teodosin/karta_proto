extends Camera2D

var panning = false
var panPoint = Vector2(0.0, 0.0)

var maxZoom: float = 5.0
var minZoom: float = 0.05

var cameraHistory: Dictionary 

signal zoomSet(zoomLvl: float)

func addToCameraHistory(focalId: int, focalPos: Vector2):
	cameraHistory[focalId] = self.position - focalPos
	
func moveToHistory(focalId: int, focalPos: Vector2):
	if not cameraHistory.has(focalId):
		return
	
	var newPos = focalPos + cameraHistory[focalId]
	var cameraTween = create_tween()
	cameraTween.tween_property(self, "position", newPos, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)

func _process(_delta):
	
	if panning:
		self.position += panPoint - get_global_mouse_position()

func animatePosition(_newPosition):
	pass
	

func _input(event):
	if event.is_action_pressed("panCamera"):
		panning = true
		panPoint = get_global_mouse_position()
	if event.is_action_released("panCamera"):
		panning = false

	if event.is_action_pressed("zoomInCamera"):
		if zoom.x >= maxZoom:
			return

		setZoom(1.1, true)
	if event.is_action_pressed("zoomOutCamera"):
		if zoom.x <= minZoom:
			return
			
		setZoom(0.9, false)

func setZoom(mult: float, toMouse: bool):
	
	self.zoom *= mult
	zoomSet.emit(mult)

	if toMouse:
				# Zoom is centered on mouse position
		var adjustedPosition = (get_global_mouse_position() - self.position) * 0.1
		self.position = self.position + adjustedPosition
