extends LineEdit

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
