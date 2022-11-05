extends Panel

var unselectedColor: Color = Color("333333")
var highlightColor: Color = Color("aa5500")
var focalColor: Color = Color("ffcc33")


var currentColor: Color = unselectedColor
# Called when the node enters the scene tree for the first time.

func _ready():
	self.modulate = currentColor

func setFocal(isTrue: bool):
	if isTrue:
		updateColor(focalColor)
	else:
		updateColor(unselectedColor)
	
func updateColor(col: Color):
	if currentColor == focalColor:
		return
		
	currentColor = col
	self.modulate = currentColor

func _on_mouse_entered():
	updateColor(highlightColor)
func _on_mouse_exited():
	updateColor(unselectedColor)
