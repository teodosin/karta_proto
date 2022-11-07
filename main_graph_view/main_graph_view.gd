extends Node2D

@onready var nodeBaseTemplate = load("res://main_graph_view/nodes/node_view_base.tscn")
@onready var wireBaseTemplate = load("res://main_graph_view/wire_view_base.tscn")

var focalNode: NodeViewBase = null
var nodeWireSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null

var dataAccess: DataAccess = DataAccessInMemory.new()

var spawnedNodes: Dictionary = {} # id -> NodeViewBase
var spawnedWires: Dictionary = {} # id -> WireViewBase


func _ready():
	dataAccess.loadData()
	
	if not dataAccess.nodes.is_empty():
		setAsFocal(dataAccess.nodes.values()[0])

func _process(_delta):
	queue_redraw()


func _input(event):
	if event.is_action_pressed("createNewNode"):
		createNode(true)
	
	if event.is_action_released("mouseRight"):
		if nodeWireSource and nodeHovering:
			createWire(nodeWireSource, nodeHovering)
		nodeWireSource = null
		nodeHovering = null


func createNode(atMouse: bool = false) -> NodeViewBase:
	
	var dataNode: NodeBase = dataAccess.addNode()
	dataAccess.saveData()

	var newNode = spawnNode(dataNode, atMouse)
	
	return newNode
	
func spawnNode(newNodeData: NodeBase, atMouse: bool):
	var position: Vector2
	if atMouse: 
		position = get_global_mouse_position()
	else: 
		position = Vector2.ZERO
	var newNode: NodeViewBase = nodeBaseTemplate.instantiate()

	newNode.id = newNodeData.id
	newNode.dataNode = newNodeData
	
	newNode.rightMousePressed.connect(self.handle_node_click.bind(newNode))
	newNode.mouseHovering.connect(self.handle_mouse_hover.bind(newNode))
	newNode.thisNodeAsFocal.connect(self.handle_node_set_itself_focal.bind(newNode))

	
	newNode.set_position(position)	
	

		
	# If there is a focal node, the new node will be automatically connected
	# to it as its target.
	add_child(newNode)
	spawnedNodes[str(newNode.id)] = newNode
	
	if not focalNode:
		setAsFocal(newNode)
		return newNode
			
	createWire(focalNode, newNode)
	
	return newNode
	

func createWire(source, target) -> WireViewBase:
	#print(source, target)
	var newWireData = dataAccess.addWire(source.id, target.id)

	dataAccess.saveData()

	var newWire = spawnWire(newWireData)
	print(spawnedWires)
	
	return newWire

func spawnWire(newWireData: WireBase) -> WireViewBase:
	var newWire: WireViewBase = wireBaseTemplate.instantiate()
	newWire.id = newWireData.id
	newWire.source = spawnedNodes[str(newWireData.sourceId)]
	newWire.target = spawnedNodes[str(newWireData.targetId)]
	
	spawnedWires[str(newWire.id)] = newWire
	#print(newWire)
	add_child(newWire)
	return newWire
	
	
func setAsFocal(node):
	if focalNode == node:
		return
	
	if spawnedNodes.is_empty():
		return
	
	if focalNode != null:
		for n in spawnedNodes:
			if spawnedNodes[n].id == focalNode.id:
				continue
			else:
				focalNode.dataNode.relatedNodes[spawnedNodes[n].id] = {
					"id": spawnedNodes[n].id, "relativePosition": spawnedNodes[n].position - focalNode.position
				}
		
	focalNode = node
	for n in spawnedNodes:
		if spawnedNodes[n].id == focalNode.id:
			continue
		spawnedNodes[n].setAsFocal(focalNode.id)
		var newPosition = focalNode.dataNode.getRelatedNodePosition(spawnedNodes[n].id, focalNode.position)
		spawnedNodes[n].animatePosition(newPosition)
	focalNode.dataNode.assignedPositions = 0
	


func _draw():
	if not focalNode: 
		return 
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.position, get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
	for w in spawnedWires:
		var wire: WireViewBase = spawnedWires[w]
		var sourcePosition: Vector2 = wire.source.position
		var targetPosition: Vector2 = wire.target.position 
		draw_line(sourcePosition, targetPosition, Color.YELLOW, 2, true)	



func _on_add_button_pressed():
	createNode()

func handle_node_click(newNode):
	nodeWireSource = newNode	

func handle_mouse_hover(newNode):
	if nodeWireSource:
		nodeHovering = newNode

func handle_node_set_itself_focal(newFocalId):
	setAsFocal(spawnedNodes[str(newFocalId.id)])
		
