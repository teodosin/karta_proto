extends Node2D

const NodeEnums = preload("res://data_access/enum_node_types.gd")
const ToolEnums = preload("res://main_graph_view/interaction_modes.gd")

@onready var nodeBaseTemplate = load("res://main_graph_view/nodes/node_view_base.tscn")
@onready var edgeBaseTemplate = load("res://main_graph_view/edge_view_base.tscn")


@onready var sceneOutputSprite: TextureRect = $SceneLayer/SceneOutputTexture


# VIEW variables that nodes listen to 
var debugView = false
var showNodeNames = true
@onready var graphZoom = $GraphViewCamera.zoom

signal debugViewSet(debug: bool)
signal showNodeNamesSet(names: bool)
signal graphZoomSet(zoom: float)

# Variable for disabling shortcuts when writing text
var shortcutsDisabled: bool = false

var dataAccess: DataAccess = DataAccessInMemory.new()

var focalNode: NodeViewBase = null
# Indexes for spawned nodes by their id
var pinnedNodes: Dictionary = {} # id -> NodeViewBase
var spawnedNodes: Dictionary = {} # id -> NodeViewBase
var spawnedEdges: Dictionary = {} # id -> EdgeViewBase

@onready var newEdgeMenu = $HUD_Layer/SideUI/NewEdgeData

# CONTROLLER variables
var activeTool: ToolEnums.interactionModes = ToolEnums.interactionModes.MOVE

var nodeEdgeSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null

func setSceneLayerOutput(active: bool):
	sceneOutputSprite.visible = active
	
func _ready():
	
	dataAccess.loadData()
	
	if not dataAccess.nodes.is_empty():	
		if dataAccess.settings.lastFocalId != 0:
			spawnNode(dataAccess.nodes[dataAccess.settings.lastFocalId])
		else:
			for noob in dataAccess.nodes.values():
				spawnNode(noob)
				break


func _process(_delta):
	if sceneOutputSprite.visible:
		#sceneOutputSprite.position = get_viewport_rect().size / 2
		if focalNode and focalNode.dataNode.nodeType == "IMAGE":
			sceneOutputSprite.texture = ImageTexture.create_from_image(focalNode.dataNode.typeData.imageResource)
	
	if focalNode == null and !spawnedNodes.is_empty():
		setAsFocal(spawnedNodes[spawnedNodes.keys()[0]])
		
	
	queue_redraw()


func createNode(nodeType: String, atMouse: bool = false) -> NodeViewBase:
	
	var dataNode: NodeBase = dataAccess.addNode(nodeType)
	
	dataAccess.saveNodeUsingResources(dataNode)

	var newNode = spawnNode(dataNode, atMouse)
	
	# If there is a focal node, the new node will be automatically connected
	# to it as its target.			
	createEdge(focalNode, newNode)	
	
	return newNode


func spawnNode(newNodeData: NodeBase, atMouse: bool = false, parent = null):
	# Just thinking here:
	# Required dependency injections (for converting to a Command):
	# newNodeData, atMouse, dataAccess, camera position, nodeBaseTemplate,
	# But what about the signal callback functions?
	# Implementing the Command pattern will require some planning
	if parent == null and focalNode != null:
		print("parent of spawned is the focal")
		parent = focalNode
	
	var spawnPos: Vector2 = $GraphViewCamera.position
	
	if atMouse: 
		spawnPos = get_global_mouse_position()
		
	elif parent != null and parent is NodeViewBase:
		if parent.dataNode.edges.keys().has(newNodeData.id): 
			spawnPos = parent.position + \
				dataAccess.edges[parent.dataNode.edges[newNodeData.id]].getConnectionPosition(parent.id)
			
	var newNode: NodeViewBase = nodeBaseTemplate.instantiate()

	newNode.id = newNodeData.id
	newNode.dataNode = newNodeData
	newNode.graphParent = parent
	
	
	# Signals from the instanced node must be connected right as the node is
	# instanced.
	newNode.gui_input.connect(self.handle_node_gui_input.bind(newNode))
	newNode.mouse_entered.connect(self.handle_node_mouse_entered.bind(newNode))
	newNode.mouse_exited.connect(self.handle_node_mouse_exited.bind(newNode))
	
	newNode.disableShortcuts.connect(self.handle_disable_shortcuts)
	newNode.nodeDataEdited.connect(self.handle_node_data_edited.bind(newNode))
	
	newNode.thisNodeAsFocal.connect(self.handle_node_set_itself_focal.bind(newNode))


	newNode.set_position(spawnPos-newNode.size/2)	

	add_child(newNode)
		
	spawnedNodes[newNode.id] = newNode
	
	dataAccess.loadNodeConnections(newNode.id)
	
	# If there is no focalNode, the first node created will become that.	
	if not focalNode:
		setAsFocal(newNode)
		newNode.setAsFocal(focalNode.id)
	
	return newNode


func createEdge(source, target, fromFocal: bool = true) -> EdgeViewBase:
	if source.id == target.id: # Don't connect node to itself
		return
	
	# TODO
	# I think that currently, adding a new edge between two nodes that already
	# have an edge will overwrite the old one. This behavior is implicit and 
	# it's possible that the old edge still remains in the file system. This
	# should be handled explicitly in some way. Duplicate edges of the same
	# EdgeType and EdgeGroup shouldn't be allowed, but multiple edges of 
	# different types and groups should be allowed to exist in parallel. If 
	# there are a massive amount, bundle them visually and make a menu for 
	# selecting individual ones.
	
#	for edge in source.dataNode.edges: # Don't connect an edge that already exists
#		if dataAccess.edges[edge].
		
	var newEdgeData = dataAccess.addEdge(source.id, target.id)
	
	source.dataNode.addEdge(target.id, newEdgeData.id)
	target.dataNode.addEdge(source.id, newEdgeData.id)
	
	newEdgeData.addSource(source.id, source.position)
	newEdgeData.addTarget(target.id, target.position)
	newEdgeData.setSourcePosition(target.id, source.position, target.position)
	newEdgeData.setTargetPosition(source.id, source.position, target.position)	
	
	# If an edge is created upon node creation, don't set the type and group.
	if !fromFocal: 
		newEdgeData.edgeType = newEdgeMenu.edgeType
		newEdgeData.edgeGroup = newEdgeMenu.edgeGroup

	dataAccess.saveEdgeUsingResources(newEdgeData)

	dataAccess.saveData()
	var newEdge = spawnEdge(newEdgeData)
	return newEdge


func spawnEdge(newEdgeData: EdgeBase) -> EdgeViewBase:
	if !spawnedNodes.keys().has(newEdgeData.sourceId) or !spawnedNodes.keys().has(newEdgeData.targetId):
		return
	
	var newEdge: EdgeViewBase = edgeBaseTemplate.instantiate()
	newEdge.edgeData = newEdgeData
	newEdge.id = newEdgeData.id
	newEdge.source = spawnedNodes[newEdgeData.sourceId]
	newEdge.target = spawnedNodes[newEdgeData.targetId]
	
	spawnedEdges[str(newEdge.id)] = newEdge

	add_child(newEdge)
	return newEdge


func saveFocalRelativePositions():
	if focalNode != null:

		for relatedId in focalNode.dataNode.edges.keys():

			var thisEdge = dataAccess.edges[focalNode.dataNode.edges[relatedId]]

			thisEdge.setConnectionPosition( \
				focalNode.id, focalNode.global_position, spawnedNodes[int(relatedId)].global_position)
			dataAccess.saveEdgeUsingResources(thisEdge)
			
			var otherNode = spawnedNodes[int(relatedId)]
			if otherNode.expanded:
				saveExpandedRelativePositions(otherNode)

func saveExpandedRelativePositions(node: NodeViewBase):
		
	for relatedId in node.dataNode.edges.keys():
		if !spawnedNodes.has(relatedId):
			print("spawnedNodes don't have this node")
			continue
		
		var otherNode = spawnedNodes[int(relatedId)]
		
		if otherNode.graphParent != node:
			continue
		
		var thisEdge = dataAccess.edges[node.dataNode.edges[relatedId]]
		print("Getting to this point here, see?")
		thisEdge.setConnectionPosition( \
			node.id, node.position, otherNode.position)
		dataAccess.saveEdgeUsingResources(thisEdge)
		
		
func expandConnections(node: NodeViewBase):
	# This function is called when a node requests spawning its own connections
	# when it is not the focal node. Spawned nodes should be added to that node
	# as its children. 
	# Expanded child nodes use their relative position to their parent to find
	# their global position, because they might not share edges with the focal.
	# Moving them should update their position relative to their parent, not 
	# relative to the focal node. They should be able to be collapsed back into
	# their parent. 
	
	node.setExpanded(true)
	var toBeSpawned = findUnspawnedRelatedNodes(node, spawnedNodes, dataAccess)
	spawnNodes(toBeSpawned, node)
	
func collapseConnections(node: NodeViewBase):
	#This function is bugged, imma put it on hold
	return
	
#	if node.expanded == false:
#		node.despawn()
#		return
#
#	for n in node.dataNode.edges:
#		if !spawnedNodes.has(n):
#			continue
#
#		if spawnedNodes[n].graphParent == node:
#			collapseConnections(spawnedNodes[n])
#
#	node.setExpanded(false)
		

func setAsFocal(node: NodeViewBase):
	# Can't set focal node if it's already the focal
	if focalNode == node:
		return
	
	# Can't set focal if no nodes are currently spawned.
	# Perhaps this requirement will change later.
	if spawnedNodes.is_empty():
		return
		
	if focalNode != null:
		focalNode.setAsFocal(node.id)
		$GraphViewCamera.addToCameraHistory(focalNode.id, focalNode.position)
	
	saveFocalRelativePositions()
	
	node.setAsFocal(node.id)
	focalNode = node
	
	dataAccess.setLastFocalId(node.id)
	
	$GraphViewCamera.moveToHistory(focalNode.id, focalNode.position)
	
	var toBeDespawned = findSpawnedToDespawn(node.dataNode.edges, spawnedNodes)
	despawnNodes(toBeDespawned)
	
	var toBeSpawned = findUnspawnedRelatedNodes(focalNode, spawnedNodes, dataAccess)
	spawnNodes(toBeSpawned)
	
	# Move spawned related nodes to new positions and reset the counter at the end
	for n in spawnedNodes.values():
		if n.id == focalNode.id:
			continue
		n.graphParent = focalNode
		var newPosition = focalNode.position + dataAccess.edges[focalNode.dataNode.edges[n.id]].getConnectionPosition(focalNode.id)
		n.animatePosition(newPosition)
	focalNode.dataNode.assignedPositions = 0
	

func findUnspawnedRelatedNodes(node: NodeViewBase, spawned, data):
	var related = node.dataNode.edges
	
	var toBeSpawned: Array[NodeBase] = []
	
	for nid in related.keys():
		if spawned.keys().has(nid):
			continue
		
		toBeSpawned.append(data.getNode(nid))
		
	return toBeSpawned
	
func spawnNodes(toBeSpawned, parent = null):
	for n in toBeSpawned:
		spawnNode(n, false, parent)
		
	for w in dataAccess.edges.values():
		spawnEdge(w)
	
	
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
	if nodeEdgeSource:
		draw_dashed_line(nodeEdgeSource.getPositionCenter(), get_global_mouse_position(), 
						Color.WHITE, 1.0, 2.0)
						
# -----------------------------------------------------------------------------

func activeToolSet(tool):
	activeTool = tool
	$HUD_Layer/SideUI/EditorViewToolmodes.select(tool)
	
func _input(event):
	# When editing names or text, the following is true.
	if shortcutsDisabled:
		return
		
	if event.is_action_pressed("createNewNode"):
		$NewNodePopup.position = get_viewport().get_mouse_position()
		$NewNodePopup.popup()

		
	# Tool shortcuts
	if event.is_action_pressed("tool_MOVE"):
		activeToolSet(ToolEnums.interactionModes.MOVE)
	if event.is_action_pressed("tool_FOCAL"):
		activeToolSet(ToolEnums.interactionModes.FOCAL)
	if event.is_action_pressed("tool_SELECT"):
		activeToolSet(ToolEnums.interactionModes.SELECT)
	if event.is_action_pressed("tool_TRANSITION"):
		activeToolSet(ToolEnums.interactionModes.TRANSITION)
	if event.is_action_pressed("tool_EDGES"):
		activeToolSet(ToolEnums.interactionModes.EDGES)
		
	if activeTool == ToolEnums.interactionModes.EDGES:
		$HUD_Layer/SideUI/NewEdgeData.visible = true
	else:
		$HUD_Layer/SideUI/NewEdgeData.visible = false


	# Global VIEW settings toggle shortcuts
	if event.is_action_pressed("debugView"):
		debugView = !debugView
		debugViewSet.emit(debugView)

	if event.is_action_pressed("toggleNodeNames"):
		showNodeNames = !showNodeNames
		showNodeNamesSet.emit(showNodeNames)
		if showNodeNames:
			$HUD_Layer/TopLeftContainer/AreNodeNamesShown.text = "Node names shown: true"
		else:
			$HUD_Layer/TopLeftContainer/AreNodeNamesShown.text = "Node names shown: false"
			
	if event.is_action_pressed("toggleOutputView"):
		setSceneLayerOutput(!sceneOutputSprite.visible)

# CONNECTED SIGNALS BELOW

#Handle the inputs forwarded from View Nodes
func handle_node_gui_input(event, node):
	if event is InputEventMouseMotion and node.nodeMoving:
		node.position += event.relative
	
		
	if event.is_action_pressed("mouseLeft"):
		
		match activeTool:
			ToolEnums.interactionModes.MOVE:
				node.nodeMoving = true
			ToolEnums.interactionModes.FOCAL:
				print("CLICKING SETS THE FOCAL TO " + str(node.id))
				setAsFocal(node)
			ToolEnums.interactionModes.EDGES:
				nodeEdgeSource = node
				
			_:
				pass
	
	if event.is_action_released("mouseLeft"):
		#Releasing the MOVE action
		if node.nodeMoving:
			node.nodeMoving = false
			saveOnNodeMoved(node)
		
		#Releasing the EDGES action, creating a new edge
		if nodeHovering != null and nodeEdgeSource != null and nodeEdgeSource != nodeHovering:
			createEdge(nodeEdgeSource, nodeHovering, false)
		
		nodeEdgeSource = null
			
	if event.is_action_pressed("mouseRight") and !shortcutsDisabled:
		var popup = $NodeRightClickMenu
		popup.position = get_viewport().get_mouse_position()
		popup.setNodeContext(node)
		popup.popup()
	
	if event.is_action_pressed("delete"):
		deleteNode(node)
		

func handle_node_mouse_entered(node):
	nodeHovering = node
func handle_node_mouse_exited(_node):
	nodeHovering = null

func handle_disable_shortcuts(disable: bool):
	shortcutsDisabled = disable
	match disable:
		false:
			$HUD_Layer/TopLeftContainer/AreShortcutsEnabled.text = "Shortcuts enabled"
		true: 
			$HUD_Layer/TopLeftContainer/AreShortcutsEnabled.text = "Shortcuts disabled"
		
func handle_node_data_edited(node: NodeViewBase):
	print("Node edited, trying to save")
	dataAccess.saveNodeUsingResources(node.dataNode)

func saveOnNodeMoved(node):
	print("TRYING TO SAVE RELATIVE POSITIONS FOR " + str(node.id) + ". (focal: " + str(node==focalNode)+")")
	# If it's an expanded node, just skip it for now. Changes are saved
	# on focal change.
	
	if node.graphParent != focalNode:
		print("Parent is not focal, but an expanded node")
	
	# If the focalNode is moved, all connected edges must be updated.
	if node == focalNode:	
		saveFocalRelativePositions()

	# If a different node is moved, only its connection to the focal 
	# needs to be updated. Remember, all positions are relative to the
	# current focal / current context.
	else:
		if is_instance_valid(node.graphParent):
			var thisEdge = dataAccess.edges[node.dataNode.edges[node.graphParent.id]]

			thisEdge.setConnectionPosition( \
				node.graphParent.id, node.graphParent.position, node.position)
			dataAccess.saveEdgeUsingResources(thisEdge)
	
	if node.expanded:
		print("moving expanded node")
		saveExpandedRelativePositions(node)

func handle_node_click(_node):
	pass
	
func handle_new_edge_drag(node):
	nodeEdgeSource = node

func handle_mouse_hover(node):
	if nodeEdgeSource:
		nodeHovering = node

func handle_node_set_itself_focal(newFocalId):
	setAsFocal(spawnedNodes[newFocalId.id])
		
	
func deleteNode(node):
	var idArray: Array = [node.id]
	
	despawnNodes(idArray)
	dataAccess.deleteNode(node.id)

# THE DELETE EVERYTHING BUTTON
func _on_button_button_down():
	despawnNodes(spawnedNodes.keys())
	dataAccess.deleteAll()

# SAVE ALL
func _on_save_all_button_button_down():
	dataAccess.saveData()

# CREATE NODE POPUP MENU
func _on_new_node_popup_id_pressed(id):
	createNode(NodeEnums.NodeTypes.keys()[id], true)

func _on_editor_view_toolmodes_tool_changed(tool):
	activeTool = tool

func _on_graph_view_camera_zoom_set(zoomLvl):
	self.graphZoom = zoomLvl
	graphZoomSet.emit(zoomLvl)

#Enable shortcuts when the focus grabber gains focus
func _on_focus_grabber_focus_entered():
	handle_disable_shortcuts(false)
