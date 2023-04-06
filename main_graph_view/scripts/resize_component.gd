extends Control

@onready var parent = get_parent()

var resizingRight: bool = false
var resizingBottom: bool = false

var previousSize: Vector2 = Vector2.ZERO
var resizeClickPosition: Vector2 = Vector2.ZERO


func _process(delta):
	
	if resizingRight:
		parent.custom_minimum_size.x = previousSize.x + (get_global_mouse_position().x - resizeClickPosition.x)
		parent.typeData.nodeSize = custom_minimum_size

	if resizingBottom:
		parent.custom_minimum_size.y = previousSize.y + (get_global_mouse_position().y - resizeClickPosition.y)
		parent.typeData.nodeSize = custom_minimum_size

func _on_right_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingRight = true
		previousSize = parent.custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingRight = false	


func _on_bottom_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingBottom = true
		previousSize = custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingBottom = false
