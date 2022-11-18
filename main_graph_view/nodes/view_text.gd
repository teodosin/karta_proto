extends TextEdit

var resizingRight: bool = false
var resizingBottom: bool = false
var resizeClickPosition: Vector2

func _ready():
	set_focus_mode(Control.FOCUS_NONE)


func _on_gui_input(event):
	if event.is_action_pressed("mouseLeft") and event.double_click:
		selecting_enabled = true
		set_focus_mode(Control.FOCUS_CLICK)
		self.grab_focus()

func _on_focus_exited():
	set_focus_mode(Control.FOCUS_NONE)
	selecting_enabled = false

func _process(_delta):
	if resizingRight:
		custom_minimum_size.x = get_global_mouse_position().x - resizeClickPosition.x 
	if resizingBottom:
		custom_minimum_size.y = get_global_mouse_position().y - resizeClickPosition.y

func _on_bottom_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingBottom = true
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingBottom = false

func _on_right_edge_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		resizingRight = true
		resizeClickPosition = get_global_mouse_position()
	if event.is_action_released("mouseLeft"):
		resizingRight = false	
