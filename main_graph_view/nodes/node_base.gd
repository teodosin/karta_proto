class_name NodeBase
extends Node2D

var id: int

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$IdLabel.text = str(id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if nodeMoving:
		self.set_position(get_global_mouse_position()-clickOffset)


func _on_control_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		clickOffset = get_global_mouse_position() - self.position
		nodeMoving = true
	if event.is_action_released("mouseLeft"):
		nodeMoving = false 
	
