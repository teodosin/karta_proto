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
	
func spawnNode(newNodeData: NodeBase, atMouse: bool = false):
	var position: Vector2
	if atMouse: 
		position = get_global_mouse_position()
	elif focalNode.dataNode.relatedNodes.keys().has(newNodeData.id): 
		position = focalNode.position - focalNode.dataNode.relatedNodes[newNodeData.id].relativePosition
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
	
 # Currently, the dataNode on each NodeViewBase and the NodeBase stored by 
 # dataAccess need to be updated separately. This is inefficient, no?

	source.dataNode.addRelatedNode(target.id)
	dataAccess.addRelatedNode(source.id, target.id, source.position, target.position)
	
	target.dataNode.addRelatedNode(source.id)
	dataAccess.addRelatedNode(target.id, source.id, target.position, source.position)


	source.dataNode.setRelatedNodePosition(target.id, source.position, target.position)
	dataAccess.updateRelatedNodePosition(source.id, target.id, source.position, target.position)
		
	target.dataNode.setRelatedNodePosition(source.id, target.position, source.position)
	dataAccess.updateRelatedNodePosition(target.id, source.id, target.position, source.position)
		
		
	dataAccess.saveData()
	var newWire = spawnWire(newWireData)
	return newWire

func spawnWire(newWireData: WireBase) -> WireViewBase:
	if !spawnedNodes.keys().has(newWireData.sourceId) or !spawnedNodes.keys().has(newWireData.targetId):
		return
	
	var newWire: WireViewBase = wireBaseTemplate.instantiate()
	newWire.id = newWireData.id
	newWire.source = spawnedNodes[newWireData.sourceId]
	newWire.target = spawnedNodes[newWireData.targetId]
	
	spawnedWires[str(newWire.id)] = newWire

	add_child(newWire)
	return newWire
	
	
func setAsFocal(node):
	# Can't set focal node if it's already the focal
	if focalNode == node:
		return
	
	# Can't set focal if no nodes are currently spawned.
	# Perhaps this requirement will change later.
	if spawnedNodes.is_empty():
		return
	
	if focalNode != null:
		"""
		for n in spawnedNodes.values():
			if n.id == focalNode.id:
				continue
			else:
				focalNode.dataNode.addRelatedNode(n.id)
				dataAccess.addRelatedNode(focalNode.id, n.id, focalNode.position, n.position)
		"""
				
		for related in focalNode.dataNode.relatedNodes.keys():
			#var relatedDataNode: NodeBase = spawnedNodes[related].dataNode
			focalNode.dataNode.addRelatedNode(related)
			dataAccess.addRelatedNode(focalNode.id, related, focalNode.position, spawnedNodes[related].position)			
	
	focalNode = node
	
	var toBeDespawned = findSpawnedToDespawn(node.dataNode.relatedNodes, spawnedNodes)
	despawnNodes(toBeDespawned)
	
	var toBeSpawned = findUnspawnedRelatedNodes(focalNode, spawnedNodes, dataAccess)
	spawnNodes(toBeSpawned)
	
	# Reposition camera on new focal node:
	# $GraphViewCamera.animatePosition(focalNode.getPositionCenter())
	
	# Move spawned related nodes to new positions and reset the counter at the end
	for n in spawnedNodes.values():
		if n.id == focalNode.id:
			continue
		n.setAsFocal(focalNode.id)
		var newPosition = focalNode.dataNode.getRelatedNodePosition(n.id, focalNode.position)
		n.animatePosition(newPosition)
	focalNode.dataNode.assignedPositions = 0
	
func findUnspawnedRelatedNodes(node: NodeViewBase, spawned, data):
	var related = node.dataNode.relatedNodes
	
	var toBeSpawned: Array[NodeBase] = []
	
	for nid in related.keys():
		if spawned.keys().has(nid):
			continue
			
		toBeSpawned.append(data.getNode(nid))
		
	return toBeSpawned
	
func spawnNodes(toBeSpawned):
	for n in toBeSpawned:
		spawnNode(n)
		
	for w in dataAccess.wires.values():
		spawnWire(w)
	
func findSpawnedToDespawn(related: Dictionary, spawned: Dictionary):
	var toBeDeleted: Array = []
	
	print("RELATED: "+str(related))
	print("SPAWNED: "+str(spawned))
	
	for n in spawned.keys():
		if n == focalNode.id:
			continue
		
		print("N is: " + str(n))
		if n not in related.keys():
			toBeDeleted.append(n)
			
	return toBeDeleted

func despawnNodes(toBeDeleted: Array):
	print("TO BE DELETED:"+str(toBeDeleted))
	for nid in toBeDeleted:
		spawnedNodes[nid].despawn()
		spawnedNodes.erase(nid)


func _draw():
	if not focalNode: 
		return 
	if nodeWireSource:
		draw_dashed_line(nodeWireSource.getPositionCenter(), get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)

# -----------------------------------------------------------------------------
# CONNECTED SIGNALS BELOW

func _on_add_button_pressed():
	createNode()

func handle_node_click(newNode):
	nodeWireSource = newNode	

func handle_mouse_hover(newNode):
	if nodeWireSource:
		nodeHovering = newNode

func handle_node_set_itself_focal(newFocalId):
	setAsFocal(spawnedNodes[newFocalId.id])
		

