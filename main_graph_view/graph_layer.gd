extends Node2D

const Enums = preload("res://data_access/enum_node_types.gd")

@onready var nodeBaseTemplate = load("res://main_graph_view/nodes/node_view_base.tscn")
@onready var wireBaseTemplate = load("res://main_graph_view/wire_view_base.tscn")

var focalNode: NodeViewBase = null
var nodeWireSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null

var debugView = false

#var dataAccess: DataAccess = DataAccessor.new()

var pinnedNodes: Dictionary = {} # id -> NodeViewBase
var spawnedNodes: Dictionary = {} # id -> NodeViewBase
var spawnedWires: Dictionary = {} # id -> WireViewBase




func _input(event):
	pass
#	if event.is_action_pressed("createNewNode"):
#		$NewNodePopup.position = get_viewport().get_mouse_position()
#		$NewNodePopup.popup()
#
#	if event.is_action_released("mouseRight"):
#		if nodeWireSource and nodeHovering:
#			createWire(nodeWireSource, nodeHovering)
#		nodeWireSource = null
#		nodeHovering = null
#
#	if event.is_action_pressed("debugView"):
#		debugView = !debugView
#		for n in get_tree().get_nodes_in_group("DEBUG"):
#
#			n.visible = debugView

#func createNode(nodeType: String, atMouse: bool = false) -> NodeViewBase:
#
#	var dataNode: NodeBase = DataAccessor.addNode(nodeType)
#
#	DataAccessor.saveData()
#
#	var newNode = spawnNode(dataNode, atMouse)
#
#	# If there is a focal node, the new node will be automatically connected
#	# to it as its target.			
#	createWire(focalNode, newNode)	
#
#	return newNode
	
#func spawnNode(newNodeData: NodeBase, atMouse: bool = false):
#	var spawnPos: Vector2
#	if atMouse: 
#		spawnPos = get_global_mouse_position()
#	if focalNode == null:
#		spawnPos = Vector2.ZERO
#	elif focalNode.dataNode.relatedNodes.keys().has(newNodeData.id): 
#		spawnPos = focalNode.position + focalNode.dataNode.relatedNodes[newNodeData.id].relativePosition
#
#	var newNode: NodeViewBase = nodeBaseTemplate.instantiate()
#
#	newNode.id = newNodeData.id
#	newNode.dataNode = newNodeData
#
#	newNode.typeData = DataAccessor.getTypeData(newNode.id)
#
#	newNode.set_position(spawnPos-newNode.size/2)	
#
#	add_child(newNode)
#	spawnedNodes[newNode.id] = newNode
#
#	# If there is no focalNode, the first node created will become that.	
#	if not focalNode:
#		setAsFocal(newNode)
#		newNode.setAsFocal(focalNode.id)
#
#	return newNode
	


func createWire(source, target) -> WireViewBase:
	if source.id == target.id:
		return
	
	var newWireData = DataAccessor.addWire(source.id, target.id)
	
	source.dataNode.addRelatedNode(target.id)
	target.dataNode.addRelatedNode(source.id)

	source.dataNode.setRelatedNodePosition(target.id, source.position, target.position)
	target.dataNode.setRelatedNodePosition(source.id, target.position, source.position)

		
	DataAccessor.saveData()
	var newWire = spawnWire(newWireData)
	return newWire



func spawnWire(newWireData: WireBaseData) -> WireViewBase:
	if !spawnedNodes.keys().has(newWireData.sourceId) or !spawnedNodes.keys().has(newWireData.targetId):
		return
	
	var newWire: WireViewBase = wireBaseTemplate.instantiate()
	newWire.id = newWireData.id
	newWire.source = spawnedNodes[newWireData.sourceId]
	newWire.target = spawnedNodes[newWireData.targetId]
	
	spawnedWires[str(newWire.id)] = newWire

	add_child(newWire)
	return newWire



func saveRelativePositions():
	if focalNode != null:

		for relatedId in focalNode.dataNode.relatedNodes.keys():
			#var relatedDataNode: NodeBase = spawnedNodes[related].dataNode
			if pinnedNodes.keys().has(relatedId):
				return

			focalNode.dataNode.setRelatedNodePosition(relatedId, focalNode.position, spawnedNodes[int(relatedId)].position)

	
func setAsPinned(nodeId):
	print(str(nodeId))
	if !spawnedNodes.keys().has(nodeId):
		return

	var node = spawnedNodes[nodeId]

	
	if spawnedNodes[nodeId].isPinned == true :
		print("SETTING AS PINNED")

		remove_child(node)
		$GraphViewCamera/PinnedNodes.add_child(node)
		print("CHILDREN Of PinLayer"+str($GraphViewCamera/PinnedNodes.get_children()))
		pinnedNodes[node.id] = node
		spawnedNodes.erase(node.id)
	elif pinnedNodes[nodeId].isPinned == false:
		$GraphViewCamera/PinnedNodes.remove_child(node)
		add_child(node)
		spawnedNodes[node.id] = node
		pinnedNodes.erase(node.id)
		print("NODESCALE" + str(node.scale))
		
#func setAsFocal(node):
#	# Can't set focal node if it's already the focal
#	if focalNode == node:
#		return
#
#	# Can't set focal if no nodes are currently spawned.
#	# Perhaps this requirement will change later.
#	if spawnedNodes.is_empty():
#		return
#
#	saveRelativePositions()	
#
#	focalNode = node
#
#	var toBeDespawned = findSpawnedToDespawn(node.dataNode.relatedNodes, spawnedNodes)
#	despawnNodes(toBeDespawned)
#
#	var toBeSpawned = findUnspawnedRelatedNodes(focalNode, spawnedNodes)
#	spawnNodes(toBeSpawned)
#
#	# Reposition camera on new focal node:
#	# $GraphViewCamera.animatePosition(focalNode.getPositionCenter())
#
#	# Move spawned related nodes to new positions and reset the counter at the end
#	for n in spawnedNodes.values():
#		if n.id == focalNode.id:
#			continue
#		n.setAsFocal(focalNode.id)
#		var newPosition = focalNode.dataNode.getRelatedNodePosition(n.id, focalNode.position)
#		n.animatePosition(newPosition)
#	focalNode.dataNode.assignedPositions = 0
#
#
	
func findUnspawnedRelatedNodes(node: NodeViewBase, spawned):
	var related = node.dataNode.relatedNodes
	
	var toBeSpawned: Array[NodeBaseData] = []
	
	for nid in related.keys():
		if spawned.keys().has(nid):
			continue
		
		toBeSpawned.append(DataAccessor.getNode(nid))
		
	return toBeSpawned
	
	
	
#func spawnNodes(toBeSpawned):
#	for n in toBeSpawned:
#		spawnNode(n)
#
#	for w in DataAccessor.wires.values():
#		spawnWire(w)
#
#
	
func findSpawnedToDespawn(related: Dictionary, spawned: Dictionary):
	var toBeDeleted: Array = []
	
	for n in spawned.keys():
		if n == focalNode.id:
			continue
		
		if n not in related.keys():
			toBeDeleted.append(n)
			
	return toBeDeleted



func despawnNodes(toBeDeleted: Array):
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

func handle_node_click(node):
	nodeWireSource = node	

func handle_mouse_hover(node):
	if nodeWireSource:
		nodeHovering = node

#func handle_node_set_itself_focal(newFocalId):
#	setAsFocal(spawnedNodes[newFocalId.id])
#
func handle_node_set_itself_pinned(node):
	setAsPinned(node.id)
	
func handle_node_delete_self(node):
	var idArray: Array = [node.id]
	
	despawnNodes(idArray)
	DataAccessor.deleteNode(node.id)

# THE DELETE EVERYTHING BUTTON
func _on_button_button_down():
	despawnNodes(spawnedNodes.keys())
	DataAccessor.deleteAll()

# SAVE ALL
func _on_save_all_button_button_down():
	saveRelativePositions()
	DataAccessor.saveData()

## CREATE NODE POPUP MENU
#func _on_new_node_popup_id_pressed(id):
#	createNode(Enums.NodeTypes.keys()[id], true)
