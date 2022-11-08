class_name NodeViewBase
extends Control

var id: int
var isFocal: bool = false

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO

var nextPosition= null
var animationSpeed: float = 50.0

var dataNode: NodeBase = null
var relatedNodes = {} # id -> NodeViewBase

signal rightMousePressed
signal mouseHovering
signal thisNodeAsFocal


func _ready():
	$BackgroundPanel/IdLabel.text = str(id)
	
# Function to get the center of the node, for drawing wires for example
func getPositionCenter() -> Vector2:
	return self.position + ($BackgroundPanel.size / 2)
	

func _process(delta):
	# Logic for smoothly moving the node to a new position
	if nextPosition != null:
		var difference = nextPosition - self.position
		if difference.length() > 0.1:
			self.set_position(self.position + difference / 2)
		else: 
			nextPosition = null
	
	# Logic for moving the node manually with the mouse
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_position(newPosition)


func setAsFocal(newFocalId):
	# If the id of the new Focal matches this node's id,
	# mark it as the new focal
	if self.id == newFocalId:	
		self.isFocal = true		
		thisNodeAsFocal.emit()
		$BackgroundPanel/FocalPanel.setFocal(true)
	else:
		$BackgroundPanel/FocalPanel.setFocal(false)
	# Is it okay to use get_parent() here?

func animatePosition(newPosition: Vector2):
	self.nextPosition = newPosition

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


func _on_focal_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft") and event.double_click:
		setAsFocal(id)
	else:
		pass
