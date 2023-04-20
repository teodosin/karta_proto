extends Panel

@export var unselectedColor: Color = Color("353545")
@export var highlightColor: Color = Color("aa5500")
@export var activeColor: Color = Color("ffcc33")


var currentColor: Color = unselectedColor

var isActive: bool = false
var onlyOn: bool = false

signal indicatorToggled

func _ready():
	self.modulate = currentColor

func setActive(isTrue: bool):
	isActive = isTrue
	if isTrue:
		updateColor(activeColor)
	else:
		updateColor(unselectedColor)
	
func updateColor(col: Color):
	currentColor = col
	self.modulate = currentColor

func _on_mouse_entered():
	if currentColor == activeColor:
		return
		
	updateColor(highlightColor)
func _on_mouse_exited():
	if currentColor == activeColor:
		return
	
	updateColor(unselectedColor)


func _on_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		indicatorToggled.emit()
		if onlyOn:
			setActive(true)
		else:
			setActive(!isActive)
	else:
		pass
