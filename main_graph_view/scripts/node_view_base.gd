class_name NodeViewBase
extends Control

var textNode = preload("res://main_graph_view/nodes/node_view_text.tscn")
var imageNode = preload("res://main_graph_view/nodes/node_view_image.tscn")

var cropImageNode = preload("res://main_graph_view/nodes/node_view_crop_image.tscn")


var inputSocket = preload("res://main_graph_view/components/input_socket.tscn")
var resizer = preload("res://main_graph_view/components/resize_component.tscn")

var id: int

@onready var indicatorPanel = $IndicatorPanel
@onready var elementContainer = get_node("NodeElementContainer")
@onready var basePanel: PanelContainer = $BackgroundPanel #get_node("BackgroundPanel")
	
var focalStylebox = StyleBoxFlat.new()


var isPinnedToFocal: bool = false
var isPinnedToPosition: bool = false
var isPinnedToUi: bool = false
var isPinnedToPresence: bool = false

var spawning = true
var despawning = false
var fadeOut = 1.0

var nodeMoving: bool = false

var dataNode: NodeBase = null

signal thisNodeAsFocal
signal thisNodeAsPinned(nodeId, isTrue)


func _ready():
	setViewType()

	# Connect the indicators
	indicatorPanel.focalIndicator.indicatorToggled.connect(self._on_focal_indicator_gui_input)
	
	var themeOverride = basePanel.get_theme_stylebox("StyleBoxFlat")
	themeOverride.border_width_left = 10
	
	# Fade in at spawn
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var spawnTween = create_tween()
	spawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)
	
	$DebugContainer/IdLabel.text = str(id)
	$DebugContainer/TypeLabel.text = str(dataNode.nodeType)
	$DebugContainer/TimeLabel.text = str(dataNode.time)
	
	$NodeName.text = str(dataNode.name)

func setViewType():
	if dataNode == null:
		return
	match dataNode.nodeType:
		"TEXT":
#			elementContainer.remove_child(basePanel)
#			basePanel.queue_free()
			
			var textPanel = textNode.instantiate()
			
#			textPanel.mouse_entered.connect(self._on_background_panel_mouse_entered)
#			textPanel.mouse_exited.connect(self._on_background_panel_mouse_exited)
#			textPanel.gui_input.connect(self._on_background_panel_gui_input)
			
			textPanel.textData = dataNode.typeData
			
#			basePanel = textPanel
			basePanel.add_child(textPanel)
		
		"IMAGE":
		
#			elementContainer.remove_child(basePanel)
#			basePanel.queue_free()
			
			var imagePanel = imageNode.instantiate()
			
#			imagePanel.mouse_entered.connect(self._on_background_panel_mouse_entered)
#			imagePanel.mouse_exited.connect(self._on_background_panel_mouse_exited)
#			imagePanel.gui_input.connect(self._on_background_panel_gui_input)
			
			imagePanel.imageData = dataNode.typeData
			
			#basePanel = imagePanel
			basePanel.add_child(imagePanel)
			
			var rszComp = resizer.instantiate()
			rszComp.setSizeUpdater(dataNode.typeData.updateSize)
			imagePanel.setAspectUpdater(rszComp.setAspectRatio)
			basePanel.add_child(rszComp)

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
	
	queue_redraw()

func _draw():
	if isPinnedToFocal:
		var highlightColor = Color(0.8, 0.4, 0.2)
		var weight: float = 5.0
		draw_line(basePanel.position, basePanel.position + Vector2(basePanel.size.x, 0), highlightColor, weight, true)
		draw_line(basePanel.position, basePanel.position +  Vector2(0, basePanel.size.y), highlightColor, weight, true)
		draw_line(basePanel.position + Vector2(basePanel.size.x, 0), basePanel.position + basePanel.size, highlightColor, weight, true)
		draw_line(basePanel.position + Vector2(0, basePanel.size.y), basePanel.position + basePanel.size, highlightColor, weight, true)
		draw_circle(basePanel.position, weight/2, highlightColor)
		draw_circle(Vector2(basePanel.size.x, 0), weight/2, highlightColor)
		draw_circle(Vector2(0, basePanel.size.y), weight/2, highlightColor)
		draw_circle(basePanel.position + basePanel.size, weight/2, highlightColor)


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
	mouse_entered.emit()

func _on_background_panel_mouse_exited():
	mouse_exited.emit()

func _on_focal_indicator_gui_input():
	print("Setting " +str(id)+ " as the focal.")
	thisNodeAsFocal.emit()
	setAsFocal(id)

func _on_node_name_text_changed(new_text):
	dataNode.name = new_text

