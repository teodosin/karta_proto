class_name NodeViewBase
extends Control

var id: int
var isFocal: bool = false

var despawning = false
var fadeOut = 1.0

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO

var prevPosition = null
var nextPosition = null
var animationStep: float = 0.0

var dataNode: NodeBase = null

signal rightMousePressed
signal mouseHovering
signal thisNodeAsFocal
signal nodeMoved


func _ready():
	$BackgroundPanel/IdLabel.text = str(id)
	
# Function to get the center of the node, for drawing wires for example
func getPositionCenter() -> Vector2:
	return self.position + ($BackgroundPanel.size / 2)
	

func _process(delta):
	# Fade-out when despawning
	if despawning:
		fadeOut -= delta * 2
		self.modulate = lerp(Color(1.0,1.0,1.0,0.0), Color(1.0,1.0,1.0,1.0), ease(fadeOut, -2.0))
		if fadeOut <= 0.0:
			get_parent().remove_child(self)
			self.queue_free()	
	
	
	# Logic for smoothly moving the node to a new position
	if nextPosition != null:
		var difference = nextPosition - prevPosition
		if self.position != nextPosition:
			self.position = lerp(prevPosition, nextPosition, ease(animationStep, -2.0))
			animationStep += delta * 1.5
		else:
			prevPosition = null
			nextPosition = null
			animationStep = 0.0
	
	# Logic for moving the node manually with the mouse
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_position(newPosition)
		if !isFocal:
			pass



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
	self.prevPosition = self.position
	self.nextPosition = newPosition

func despawn():
	despawning = true
		# Also remove the node from the array of references

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
