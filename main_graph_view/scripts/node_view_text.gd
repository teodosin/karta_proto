extends TextEdit

var textData: NodeText


func _ready():
	if textData:
		text = textData.nodeText
		get_parent().custom_minimum_size = textData.nodeSize
		
	set_focus_mode(Control.FOCUS_NONE)


func _on_text_changed():
	textData.updateText(text)
	
	get_parent().owner.nodeDataEdited.emit()


func _on_focus_exited():
	get_parent().owner.disableShortcuts.emit(false)
	set_focus_mode(Control.FOCUS_NONE)
	selecting_enabled = false
	
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	context_menu_enabled = false
	get_parent().mouse_filter = Control.MOUSE_FILTER_PASS

func _on_gui_input(event):
	if event.is_action_pressed("mouseLeft") and event.double_click:
		selecting_enabled = true
		set_focus_mode(Control.FOCUS_CLICK)
		grab_focus()
		
		get_parent().mouse_filter = Control.MOUSE_FILTER_STOP
		get_parent().owner.disableShortcuts.emit(true)
		mouse_default_cursor_shape = Control.CURSOR_IBEAM
		context_menu_enabled = true

func _on_focus_entered():
	pass
