extends TextEdit

var resizingRight: bool = false
var resizingBottom: bool = false
var resizeClickPosition: Vector2

func _ready():
	set_focus_mode(Control.FOCUS_NONE)

func _on_focus_exited():
	set_focus_mode(Control.FOCUS_NONE)
	selecting_enabled = false


func _on_gui_input(event):
	if event.is_action_pressed("mouseLeft") and event.double_click:
		selecting_enabled = true
		set_focus_mode(Control.FOCUS_CLICK)
		grab_focus()
