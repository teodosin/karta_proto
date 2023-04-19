class_name NodeViewBase
extends Control

var textNode = preload("res://main_graph_view/nodes/node_view_text.tscn")
var imageNode = preload("res://main_graph_view/nodes/node_view_image.tscn")

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
var typeData = null

signal rightMousePressed
signal mouseHovering

signal thisNodeAsFocal
signal thisNodeAsPinned(nodeId, isTrue)

signal nodeMoved
signal nodeDeleteSelf


func _ready():
	match dataNode.nodeType:
		"TEXT":
			var basePanel = $VBoxContainer/BackgroundPanel
			$VBoxContainer.remove_child(basePanel)
			basePanel.queue_free()
			
			var textPanel = textNode.instantiate()
			
			textPanel.mouse_entered.connect(self._on_background_panel_mouse_entered)
			textPanel.mouse_exited.connect(self._on_background_panel_mouse_exited)
			textPanel.gui_input.connect(self._on_background_panel_gui_input)
			
			textPanel.textData = typeData
			
			$VBoxContainer.add_child(textPanel)
		
		"IMAGE":
			var basePanel = $VBoxContainer/BackgroundPanel
			$VBoxContainer.remove_child(basePanel)
			basePanel.queue_free()
			
			var imagePanel = imageNode.instantiate()
			
			imagePanel.mouse_entered.connect(self._on_background_panel_mouse_entered)
			imagePanel.mouse_exited.connect(self._on_background_panel_mouse_exited)
			imagePanel.gui_input.connect(self._on_background_panel_gui_input)
			
			imagePanel.imageData = typeData
			
			$VBoxContainer.add_child(imagePanel)
			
		_: 
			$VBoxContainer/BackgroundPanel.mouse_entered.connect(self._on_background_panel_mouse_entered)
			$VBoxContainer/BackgroundPanel.mouse_exited.connect(self._on_background_panel_mouse_exited)
			$VBoxContainer/BackgroundPanel.gui_input.connect(self._on_background_panel_gui_input)

			
	# Fade in at spawn
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var spawnTween = create_tween()
	spawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)
	
	$DebugContainer/IdLabel.text = str(id)
	$DebugContainer/TypeLabel.text = str(dataNode.nodeType)
	$DebugContainer/TimeLabel.text = str(dataNode.time)
	
	$NodeName.text = str(dataNode.name)
	
# Function to get the center of the node, for drawing edges for example
func getPositionCenter() -> Vector2:
	return self.global_position + $VBoxContainer.size / 2
	

func _process(delta):

	# Logic for moving the node manually with the mouse
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_position(newPosition)
		if !isFocal:
			pass

func setAsPinned():
	return
	
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
	tween.tween_property(self, "position", newPosition, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	

func despawn():
	var despawnTween = create_tween()
	despawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.2).set_ease(Tween.EASE_IN)
	despawnTween.tween_callback(deleteSelf)
		# Also remove the node from the array of references
func deleteSelf():
	get_parent().remove_child(self)
	self.queue_free()	

func _on_background_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft") and $VBoxContainer.get_child(1).has_focus():
		clickOffset = get_global_mouse_position() - self.position
		nodeMoving = true
	if event.is_action_released("mouseLeft"):
		nodeMoving = false
		
	if event.is_action_pressed("mouseRight"):
		rightMousePressed.emit()
	if event.is_action_released("mouseRight"):
		pass
		
	if event.is_action_pressed("delete"):
		nodeDeleteSelf.emit()


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
