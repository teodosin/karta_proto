class_name NodeViewBase
extends Control

var id: int
var isFocal: bool = false
var isPinned: bool = false

var spawning = true
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
signal thisNodeAsPinned(nodeId, isTrue)

signal nodeMoved


func _ready():
	
	
	$DebugContainer/IdLabel.text = str(id)
	$DebugContainer/TypeLabel.text = str(dataNode.nodeType)
	$NodeName.text = str(dataNode.name)
	
# Function to get the center of the node, for drawing wires for example
func getPositionCenter() -> Vector2:
	return self.position + ($VBoxContainer/BackgroundPanel.size / 2)
	

func _process(delta):
	# fade In when spawning
	
	if spawning:
		fadeOut -= delta * 3
		self.modulate = lerp(Color(1.0,1.0,1.0,1.0), Color(1.0,1.0,1.0,0.0), ease(fadeOut, -2.0))
		if fadeOut <= 0.0:
			spawning = false
			fadeOut = 1.0
	
	# Fade-out when despawning
	if despawning:
		fadeOut -= delta * 3
		self.modulate = lerp(Color(1.0,1.0,1.0,0.0), Color(1.0,1.0,1.0,1.0), ease(fadeOut, -2.0))
		if fadeOut <= 0.0:
			get_parent().remove_child(self)
			self.queue_free()	
	
	
	# Logic for moving the node manually with the mouse
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_position(newPosition)
		if !isFocal:
			pass

func setAsPinned():
	isPinned = !isPinned
	thisNodeAsPinned.emit()
	$VBoxContainer/Indicators/PinnedPanel.setPinned(isPinned)
	


func setAsFocal(newFocalId):
	if isPinned:
		return 
	# If the id of the new Focal matches this node's id,
	# mark it as the new focal
	if self.id == newFocalId:	
		self.isFocal = true		
		thisNodeAsFocal.emit()
		$VBoxContainer/Indicators/FocalPanel.setFocal(true)
	else:
		self.isFocal = false
		$VBoxContainer/Indicators/FocalPanel.setFocal(false)
	# Is it okay to use get_parent() here?

func animatePosition(newPosition):
	var tween = create_tween()
	tween.tween_property(self, "position", newPosition, 0.5).set_ease(Tween.EASE_IN_OUT)
	

func despawn():
	despawning = true
		# Also remove the node from the array of references

func _on_background_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft") and \
		!$VBoxContainer/BackgroundPanel/VBoxContainer/TextEdit.has_focus() and \
		!$VBoxContainer/BackgroundPanel.resizingBottom and \
		!$VBoxContainer/BackgroundPanel.resizingRight:
		
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

func _on_node_name_text_changed(new_text):
	dataNode.name = new_text
	
	


func _on_pinned_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		setAsPinned()
