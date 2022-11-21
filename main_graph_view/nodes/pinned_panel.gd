extends Panel

var unselectedColor: Color = Color("334373")
var highlightColor: Color = Color("aa0055")
var pinnedColor: Color = Color("bbccff")


var currentColor: Color = unselectedColor
# Called when the node enters the scene tree for the first time.

func _ready():
	self.modulate = currentColor

func setPinned(isTrue: bool):
	if isTrue:
		updateColor(pinnedColor)
	else:
		updateColor(unselectedColor)
	
func updateColor(col: Color):
	currentColor = col
	self.modulate = currentColor

func _on_mouse_entered():
	if currentColor == pinnedColor:
		return
		
	updateColor(highlightColor)
func _on_mouse_exited():
	if currentColor == pinnedColor:
		return
	
	updateColor(unselectedColor)
