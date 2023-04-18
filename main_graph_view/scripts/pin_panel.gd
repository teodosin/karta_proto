extends Panel

@export var unselectedColor: Color = Color("000015")
@export var highlightColor: Color = Color("aa5500")
@export var focalColor: Color = Color("ffcc33")


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
	currentColor = col
	self.modulate = currentColor

func _on_mouse_entered():
	if currentColor == focalColor:
		return
		
	updateColor(highlightColor)
func _on_mouse_exited():
	if currentColor == focalColor:
		return
	
	updateColor(unselectedColor)
