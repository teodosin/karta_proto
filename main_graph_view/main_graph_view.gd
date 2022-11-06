extends Node2D

@onready var nodeBaseTemplate = load("res://main_graph_view/nodes/node_view_base.tscn")

var focalNode: NodeViewBase = null
var nodeWireSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null

var dataAccess: DataAccess = DataAccessInMemory.new()

signal focalSet


func _ready():
	pass
func _process(_delta):
	queue_redraw()



func _input(event):
	if event.is_action_pressed("createNewNode"):
		createNode(true)
	
	if event.is_action_released("mouseRight"):
		if nodeWireSource and nodeHovering:
			dataAccess.addWire(nodeWireSource.id, nodeHovering.id)
			print("kaka " + str(nodeHovering.id) + " " + str(nodeWireSource.id))
		nodeWireSource = null
		nodeHovering = null
		
		
		
func createNode(atMouse: bool = false) -> NodeViewBase:
	var position: Vector2
	if atMouse: 
		position = get_global_mouse_position()
	else: 
		position = Vector2.ZERO
	var newNode = nodeBaseTemplate.instantiate()
	var newId = dataAccess.addNode(position)
	newNode.id = newId
	
	newNode.rightMousePressed.connect(self.handle_node_click.bind(newNode))
	newNode.mouseHovering.connect(self.handle_mouse_hover.bind(newNode))
	newNode.thisNodeAsFocal.connect(self.handle_node_set_itself_focal.bind(newNode))
	
	newNode.set_position(position)	
	
	if not focalNode:
		setAsFocal(newNode)
		
	# If there is a focal node, the new node will be automatically connected
	# to it as its target.
	dataAccess.addWire(focalNode.id, newNode.id)
		
	add_child(newNode)
	return newNode
	
func setAsFocal(node):
	focalNode = node
	focalSet.emit(focalNode.id)

func _draw():
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.position, get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
		
# for now just draw all wires,
# once we add the logic for focal nodes, we will have to 
# select a subset of wires to draw (for example only
# between nodes that are related to focal node)  
	for w in dataAccess.getAllWires():
		var wire: WireBase = w
		var sourceNode: NodeBase = dataAccess.getNode(wire.sourceId)
		var targetNode: NodeBase = dataAccess.getNode(wire.targetId)
		draw_line(sourceNode.position, targetNode.position, Color.YELLOW, 2, true)	


func _on_add_button_pressed():
	if focalNode == null:
		focalNode = createNode()
		focalNode.position = get_viewport_rect().size / 2
	else: 
		var relatedNode = createNode()
		dataAccess.addWire(focalNode.id, relatedNode.id)
		dataAccess.addRelatedNode(focalNode.id, relatedNode.id, relatedNode.position - focalNode.position)
		
func handle_node_click(newNode):
	nodeWireSource = newNode	
func handle_mouse_hover(newNode):
	if nodeWireSource:
		nodeHovering = newNode
func handle_node_set_itself_focal(newNode):
	setAsFocal(newNode)
		
