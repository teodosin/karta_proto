class_name NodeViewBase
extends Control

var id: int

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO

signal rightMousePressed
signal mouseHovering

# Called when the node enters the scene tree for the first time.
func _ready():
	$IdLabel.text = str(id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if nodeMoving:
		self.set_position(get_global_mouse_position()-clickOffset)



func _on_background_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		clickOffset = get_global_mouse_position() - self.position
		nodeMoving = true
	if event.is_action_released("mouseLeft"):
		nodeMoving = false 
		
	if event.is_action_pressed("mouseRight"):
		rightMousePressed.emit()
	if event.is_action_released("mouseRight"):
		pass


func _on_background_panel_mouse_entered():
	mouseHovering.emit()

func _on_background_panel_mouse_exited():
	pass # Replace with function body.
