extends Control

var aspect: float = 1.0 # height / width

var resizingRight: bool = false
var resizingBottom: bool = false
var previousSize: Vector2
var resizeClickPosition: Vector2

var sizeUpdater: Callable

func setAspectRatio(aspct: float):
	aspect = aspct

func setSizeUpdater(function: Callable):
	sizeUpdater = function

func _process(_delta):
	if resizingRight:
		get_parent().custom_minimum_size.x = previousSize.x + (get_global_mouse_position().x - resizeClickPosition.x)
		
		get_parent().custom_minimum_size.y = get_parent().custom_minimum_size.x / aspect
		sizeUpdater.call(get_parent().custom_minimum_size)
		
	if resizingBottom:
		get_parent().custom_minimum_size.y = previousSize.y + (get_global_mouse_position().y - resizeClickPosition.y)
		
		get_parent().custom_minimum_size.x = get_parent().custom_minimum_size.y * aspect
		sizeUpdater.call(get_parent().custom_minimum_size)


func _on_bottom_edge_gui_input(event):
	assert(sizeUpdater)
	
	if event.is_action_pressed("mouseLeft"):
		resizingBottom = true
		previousSize = get_parent().custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingBottom = false

func _on_right_edge_gui_input(event):
	assert(sizeUpdater)
	
	if event.is_action_pressed("mouseLeft"):
		resizingRight = true
		previousSize = get_parent().custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingRight = false	









