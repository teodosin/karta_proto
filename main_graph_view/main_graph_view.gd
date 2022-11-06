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
	var newNode: NodeViewBase = nodeBaseTemplate.instantiate()
	var dataNode: NodeBase = dataAccess.addNode()
	newNode.id = dataNode.id
	newNode.dataNode = dataNode
	
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
	if not focalNode: 
		return 
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.position, get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
	for w in dataAccess.getAllWires():
		var wire: WireBase = w
		var sourcePosition: Vector2 = _findRelatedPosition(wire.sourceId)
		var targetPosition: Vector2 = _findRelatedPosition(wire.targetId)
		if sourcePosition != null and targetPosition != null: 
			draw_line(sourcePosition, targetPosition, Color.YELLOW, 2, true)	


func _findRelatedPosition(wireEndId: int) -> Vector2:
	var nodeData: NodeBase = focalNode.dataNode
	var position: Vector2
	if wireEndId == focalNode.id: 
		position = focalNode.position
	elif nodeData.relatedNodes.has(wireEndId): 
		position = focalNode.position + nodeData.relatedNodes[wireEndId]
	else: 
		position = Vector2.INF
	return position


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
		
