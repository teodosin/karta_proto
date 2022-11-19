extends PanelContainer


var resizingRight: bool = false
var resizingBottom: bool = false
var previousSize: Vector2
var resizeClickPosition: Vector2


func _process(_delta):
	if resizingRight:
		custom_minimum_size.x = previousSize.x + (get_global_mouse_position().x - resizeClickPosition.x)
		print("RESIZING HORIZONTAL")
	if resizingBottom:
		custom_minimum_size.y = previousSize.y + ( get_global_mouse_position().y - resizeClickPosition.y)
		print("RESIZING VERTICAL")

func _on_bottom_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingBottom = true
		previousSize = custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingBottom = false

func _on_right_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingRight = true
		previousSize = custom_minimum_size
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingRight = false	
