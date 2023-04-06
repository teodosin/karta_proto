extends Node2D


var panning = false
var panPoint = Vector2(0.0, 0.0)

func _physics_process(_delta):
	
	if panning:
		$GraphLayer.position = panPoint + get_global_mouse_position()

func animatePosition(newPosition):
	pass
	

func _input(event):
	if event.is_action_pressed("panCamera"):
		panning = true
		panPoint = $GraphLayer.position - get_global_mouse_position()
	if event.is_action_released("panCamera"):
		panning = false


	if event.is_action_pressed("zoomInCamera"):
		if $GraphLayer.scale.x >= 1.0:
			return
		setZoom(1.1, true)
		
	if event.is_action_pressed("zoomOutCamera"):
		if $GraphLayer.scale.x <= 0.4:
			return
	
		setZoom(0.9, false)
		$GraphLayer.position *= 0.9

func setZoom(mult: float, toMouse: bool):
	
	$GraphLayer.scale *= mult

	if toMouse:
				# Zoom is centered on mouse position
		var adjustedPosition = (get_global_mouse_position() - $GraphLayer.position) * -0.1
		$GraphLayer.position = $GraphLayer.position + adjustedPosition
