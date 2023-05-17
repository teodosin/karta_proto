class_name NodeViewBase
extends Control

# Load ViewNode types 
var textNode = preload("res://main_graph_view/nodes/node_view_text.tscn")
var imageNode = preload("res://main_graph_view/nodes/node_view_image.tscn")

var sceneNode = preload("res://main_graph_view/nodes/node_view_scene.tscn")

# Load components
var resizer = preload("res://main_graph_view/components/resize_component.tscn")

var id: int

@onready var indicatorPanel = $IndicatorPanel
@onready var elementContainer = get_node("NodeElementContainer")
@onready var basePanel: PanelContainer = $BackgroundPanel #get_node("BackgroundPanel")
	

var dataNode: NodeBase = null
var graphParent: NodeViewBase

# Variables for highlighting
var focalHighlightColor = Color(0.8, 0.4, 0.2)
var weight: float = 9.0

var isPinnedToFocal: bool = false
var isPinnedToPosition: bool = false
var isPinnedToUi: bool = false
var isPinnedToPresence: bool = false

# Variables concerning state
var nodeMoving: bool = false
var mouseHovering: bool = false
var expanded: bool = false

signal thisNodeAsFocal
signal thisNodeAsPinned(nodeId, isTrue)

signal nodeDataEdited

signal disableShortcuts(disable: bool)


func _ready():
	setViewType()

	# Connect the indicators
	indicatorPanel.focalIndicator.indicatorToggled.connect(self._on_focal_indicator_gui_input)
	
	# Fade in at spawn
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var spawnTween = create_tween()
	spawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)
	
	#Set debugging data to labels
	$DebugContainer/IdLabel.text = str(id)
	$DebugContainer/TypeLabel.text = str(dataNode.nodeType)
	$DebugContainer/DataTypeLabel.text = str(dataNode.dataType)
	$DebugContainer/TimeLabel.text = str(dataNode.time)
	
	#Initialise node name
	$NodeName.text = str(dataNode.name)
	
	#Hide it according to the setting 
	if get_tree().current_scene.showNodeNames:
		$NodeName.visible = true
	else:
		$NodeName.visible = false
	
	#Connect signals for reacting to changes in VIEW settings
	get_tree().current_scene.debugViewSet.connect(self.handle_debug_view_set)
	get_tree().current_scene.showNodeNamesSet.connect(self.handle_node_name_set)
	get_tree().current_scene.graphZoomSet.connect(self.handle_graph_zoom_set)
	
func handle_debug_view_set(debug: bool):
	$DebugContainer.visible = debug
func handle_node_name_set(namen: bool):
	$NodeName.visible = namen
func handle_graph_zoom_set(zoom: float):
	weight /= zoom
	
func setExpanded(expand: bool):
	expanded = expand

func setViewType():
	if dataNode == null:
		return
	match dataNode.nodeType:
		"TEXT":
			var textPanel = textNode.instantiate()
			
			textPanel.textData = dataNode.typeData
			
			basePanel.add_child(textPanel)
			
			var rszComp = resizer.instantiate()
			rszComp.setSizeUpdater(dataNode.typeData.updateSize)
			basePanel.add_child(rszComp)
		
		"IMAGE":
			var imagePanel = imageNode.instantiate()

			imagePanel.imageData = dataNode.typeData
			
			basePanel.add_child(imagePanel)
			
			var rszComp = resizer.instantiate()
			rszComp.setSizeUpdater(dataNode.typeData.updateSize)
			rszComp.enforceAspect = true
			imagePanel.setAspectUpdater(rszComp.setAspectRatio)
			basePanel.add_child(rszComp)
		
		"SCENE":
			var scenePanel = sceneNode.instantiate()
			
			scenePanel.sceneData = dataNode.typeData
			basePanel.add_child(scenePanel)

		_: 
			pass
			
	# Rename the node if no name has been assigned
	if dataNode.name == "node":
		dataNode.name = dataNode.nodeType
		
# Function to get the center of the node, for drawing edges for example
func getPositionCenter() -> Vector2:
	return self.global_position + basePanel.size / 2


func setAsFocal(newFocalId):

	# If the id of the new Focal matches this node's id,
	# mark it as the new focal
	if self.id == newFocalId:	
		self.isPinnedToFocal = true		
		#thisNodeAsFocal.emit()
		$IndicatorPanel.focalIndicator.setActive(true)
		
	else:
		self.isPinnedToFocal = false
		$IndicatorPanel.focalIndicator.setActive(false)
	# Is it okay to use get_parent() here?

func _process(_delta):
	queue_redraw()

func _draw():
	if isPinnedToFocal:
		drawFrame(focalHighlightColor, weight)
		
	if basePanel.has_focus():
		drawFrame(Color(1.0, 1.0, 1.0), weight/4)
		
	if mouseHovering:
		drawFrame(Color(0.7, 0.7, 0.7), weight/6)

func drawFrame(frameColor: Color, wgt: float):
		draw_line(basePanel.position, basePanel.position + Vector2(basePanel.size.x, 0), frameColor, wgt, true)
		draw_line(basePanel.position, basePanel.position +  Vector2(0, basePanel.size.y), frameColor, wgt, true)
		draw_line(basePanel.position + Vector2(basePanel.size.x, 0), basePanel.position + basePanel.size, frameColor, wgt, true)
		draw_line(basePanel.position + Vector2(0, basePanel.size.y), basePanel.position + basePanel.size, frameColor, wgt, true)
		draw_circle(basePanel.position, wgt/2, frameColor)
		draw_circle(Vector2(basePanel.size.x, 0), wgt/2, frameColor)
		draw_circle(Vector2(0, basePanel.size.y), wgt/2, frameColor)
		draw_circle(basePanel.position + basePanel.size, wgt/2, frameColor)

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

#getters
func getIsPinnedToFocal():
	return isPinnedToFocal
	
func getIsPinnedToPosition():
	return isPinnedToPresence
	
func getIsPinnedToUi():
	return isPinnedToUi 
	
func getIsPinnedToPresence():
	return isPinnedToPresence

#signal callback functions
func _on_background_panel_gui_input(event):
	gui_input.emit(event)

func _on_background_panel_mouse_entered():
	mouseHovering = true
	mouse_entered.emit()

func _on_background_panel_mouse_exited():
	mouseHovering = false
	mouse_exited.emit()

func _on_focal_indicator_gui_input():
	print("Setting " +str(id)+ " as the focal.")
	thisNodeAsFocal.emit()
	setAsFocal(id)

func _on_node_name_text_changed(new_text):
	dataNode.name = new_text
	nodeDataEdited.emit()


# Move node in front of others when on focus. Ugly solution, but works for now. 
func _on_background_panel_focus_entered():
	self.z_index = 1
func _on_background_panel_focus_exited():
	self.z_index = 0
