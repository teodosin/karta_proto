class_name NodeViewBase
extends Control


var id: int
var isFocal: bool = false # Nodes are spawned according to the context set by the focal
var isPinnedToGraph: bool = false # Nodes are unaffected by the force-directed simulation
var isPinnedToUI: bool = false # Nodes are moved to the UI Layer
var isPinnedToPresence: bool = false # Nodes aren't despawned when out of scope

var spawning = true
var despawning = false
var fadeOut = 1.0

var nodeMoving: bool = false
var clickOffset: Vector2 = Vector2.ZERO

var nodeData: NodeBaseData

@onready var nodeNameLabelScene = load("res://main_graph_view/components/node_name_label.tscn")
@onready var pinPanelScene = load("res://main_graph_view/components/pin_indicator_panel.tscn")
@onready var debugPanelScene = load("res://main_graph_view/components/debug_panel.tscn")

func baseReady():
	# Fade in at spawn
	self.modulate = Color(1.0, 1.0, 1.0, 0.0)
	var spawnTween = create_tween()
	spawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT)
	
	
	var nodeNameLabel = nodeNameLabelScene.instantiate()
	nodeNameLabel.text = str(nodeData.name)
	#add_child(nodeNameLabel)
	
	var pinPanel = pinPanelScene.instantiate()
	#add_child(pinPanel)
	
func loadAdjacentNodes():
	pass
	
func baseProcess():
	if nodeMoving:
		var newPosition: Vector2 = get_global_mouse_position()-clickOffset

		self.set_global_position(newPosition)
		
		
# Function to get the center of the node, for drawing wires for example
func getPositionCenter() -> Vector2:
	return self.position + self.size / 2
	

func togglePinnedToGraph() -> void:
	return
	
	isPinnedToGraph = !isPinnedToGraph
	GraphManager.pinNodeToGraph()
	#$VBoxContainer/Indicators/PinnedPanel.setPinnedToGraph(isPinnedToGraph)
	
func togglePinnedToUI() -> void:
	pass

func setAsFocal(newFocalId):

	# If the id of the new Focal matches this node's id,
	# mark it as the new focal
	if self.id == newFocalId:	
		self.isFocal = true		
		#$IndicatorPanel/FocalButton.setFocal(true)
	else:
		self.isFocal = false
		#$IndicatorPanel/FocalButton.setFocal(false)

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

func _on_background_panel_mouse_entered():
	pass


func _on_background_panel_mouse_exited():
	pass # Replace with function body.


func _on_focal_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft") and event.double_click:
		GraphManager.setAsFocal(self)
	else:
		pass

func _on_node_name_text_changed(new_text):
	nodeData.name = new_text
	
	


func _on_pinned_panel_gui_input(event):
	if event.is_action_pressed("mouseLeft"):
		togglePinnedToGraph()



func on_self_input(event):
	if event.is_action_pressed("mouseRight") and event.double_click:
		GraphManager.setAsFocal(self)
	else:
		pass
		
	if event.is_action_pressed("mouseLeft"):

		clickOffset = get_global_mouse_position() - self.global_position
			
		nodeMoving = true




		
	if event.is_action_released("mouseLeft"):
		nodeMoving = false
		
	if event.is_action_pressed("mouseRight"):
		pass
		
	if event.is_action_released("mouseRight"):
		pass
		
	if event.is_action_pressed("delete"):
		GraphManager.deleteNode(self.id)
