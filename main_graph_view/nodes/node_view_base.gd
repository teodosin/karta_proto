class_name NodeViewBase
extends Control

var id: int
var isFocal: bool = false

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO
var dataNode: NodeBase = null
var relatedNodes = {} # id -> NodeViewBase

signal rightMousePressed
signal mouseHovering
signal thisNodeAsFocal

# Called when the node enters the scene tree for the first time.
func _ready():
	$IdLabel.text = str(id)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_position(newPosition)
			#get_parent().dataAccess.updateNodePosition(id, newPosition)
			

func setAsFocal(newFocalId):
	if self.id == newFocalId:	
		self.isFocal = true		
		thisNodeAsFocal.emit()
		$BackgroundPanel/FocalPanel.setFocal(true)
	else:
		$BackgroundPanel/FocalPanel.setFocal(false)
	# Is it okay to use get_parent() here?



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
