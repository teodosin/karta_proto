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
	
	# Signals from the instanced node must be connected right as the node is
	# instanced.
	newNode.rightMousePressed.connect(self.handle_node_click.bind(newNode))
	newNode.mouseHovering.connect(self.handle_mouse_hover.bind(newNode))
	newNode.thisNodeAsFocal.connect(self.handle_node_set_itself_focal.bind(newNode))

	
	newNode.set_position(position)	
	

		
	# If there is a focal node, the new node will be automatically connected
	# to it as its target.
	add_child(newNode)
	spawnedNodes[newNode.id] = newNode
	
	# If there is no focalNode, the first node created will become that.
	if not focalNode:
		setAsFocal(newNode)
		newNode.setAsFocal(focalNode.id)
		
		# The last step is creating the wire that connects the new node to the 
		# focal node. We want to skip that if the current node becomes the focal,
		# and we do that by returning newNode here.
		return newNode
			
	createWire(focalNode, newNode)
	
	return newNode
	

func createWire(source, target) -> WireViewBase:
	var newWireData = dataAccess.addWire(source.id, target.id)
	dataAccess.saveData()
	var newWire = spawnWire(newWireData)
	return newWire

func spawnWire(newWireData: WireBase) -> WireViewBase:
	var newWire: WireViewBase = wireBaseTemplate.instantiate()
	newWire.id = newWireData.id
	newWire.source = spawnedNodes[newWireData.sourceId]
	newWire.target = spawnedNodes[newWireData.targetId]
	
	spawnedWires[str(newWire.id)] = newWire

	add_child(newWire)
	return newWire
	
	
func setAsFocal(node):
	if focalNode == node:
		return
	
	if spawnedNodes.is_empty():
		return
	
	if focalNode != null:
		for n in spawnedNodes.values():
			if n.id == focalNode.id:
				continue
			else:
				focalNode.dataNode.relatedNodes[n.id] = {
					"id": n.id, "relativePosition": n.position - focalNode.position
				}
		for related in focalNode.dataNode.relatedNodes.keys():
			print(focalNode.id)
			spawnedNodes[related].dataNode.relatedNodes[focalNode.id] = {
				"id": related, "relativePosition": focalNode.position - spawnedNodes[related.id].position 
			}
		
	focalNode = node
	
	var toBeDeleted = findSpawnedToDelete(focalNode.dataNode.relatedNodes, spawnedNodes)
	deleteNodes(toBeDeleted)
	
	# Reposition camera on new focal node 
	# $GraphViewCamera.animatePosition(focalNode.position)
	for n in spawnedNodes.values():
		if n.id == focalNode.id:
			continue
		n.setAsFocal(focalNode.id)
		var newPosition = focalNode.dataNode.getRelatedNodePosition(n.id, focalNode.position)
		n.animatePosition(newPosition)
	focalNode.dataNode.assignedPositions = 0
	
func findSpawnedToDelete(related: Dictionary, spawned: Dictionary):
	var toBeDeleted: Array = []
	
	print("RELATED: "+str(related))
	print("SPAWNED: "+str(spawned))
	
	for n in spawned.keys():

		if n not in related and n != focalNode.id:
			toBeDeleted.append(n)
			
	return toBeDeleted

func deleteNodes(toBeDeleted: Array):
	print("TO BE DELETED:"+str(toBeDeleted))
	for nid in toBeDeleted:
		remove_child(spawnedNodes[nid])
		#spawnedNodes[nid].queue_free()

func _draw():
	if not focalNode: 
		return 
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.getPositionCenter(), get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
	for w in spawnedWires:
		var wire: WireViewBase = spawnedWires[w]
		var sourcePosition: Vector2 = wire.source.getPositionCenter()
		var targetPosition: Vector2 = wire.target.getPositionCenter()
		draw_line(sourcePosition, targetPosition, Color.YELLOW, 2, true)	



func _on_add_button_pressed():
	createNode()

func handle_node_click(newNode):
	nodeWireSource = newNode	

func handle_mouse_hover(newNode):
	if nodeWireSource:
		nodeHovering = newNode

func handle_node_set_itself_focal(newFocalId):
	setAsFocal(spawnedNodes[newFocalId.id])
		
