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

# CONTROLLER variables
var activeTool: ToolEnums.interactionModes = ToolEnums.interactionModes.MOVE

var nodeEdgeSource: NodeViewBase = null
var nodeHovering: NodeViewBase = null
var socketHovering: InputSocket = null

func setSceneLayerOutput(active: bool):
	sceneOutputSprite.visible = active
	
func _ready():
	
	dataAccess.loadData()
	
	if not dataAccess.nodes.is_empty():	
		for noob in dataAccess.nodes.values():
			spawnNode(noob)
			break
		
func _process(_delta):
	if sceneOutputSprite.visible:
		#sceneOutputSprite.position = get_viewport_rect().size / 2
		if focalNode and focalNode.dataNode.nodeType == "IMAGE":
			sceneOutputSprite.texture = ImageTexture.create_from_image(focalNode.dataNode.typeData.imageResource)
	
	if focalNode == null:
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
	
func spawnNode(newNodeData: NodeBase, atMouse: bool = false):
	var spawnPos: Vector2
	if atMouse: 
		spawnPos = get_global_mouse_position()
	if focalNode == null:
		spawnPos = $GraphViewCamera.position
	elif focalNode.dataNode.edges.keys().has(newNodeData.id): 
		spawnPos = focalNode.position + \
			dataAccess.edges[focalNode.dataNode.edges[newNodeData.id]].getConnectionPosition(focalNode.id)
			
	var newNode: NodeViewBase = nodeBaseTemplate.instantiate()

	newNode.id = newNodeData.id
	newNode.dataNode = newNodeData
	
	
	# Signals from the instanced node must be connected right as the node is
	# instanced.
	newNode.gui_input.connect(self.handle_node_gui_input.bind(newNode))
	newNode.mouse_entered.connect(self.handle_node_mouse_entered.bind(newNode))
	newNode.mouse_exited.connect(self.handle_node_mouse_exited.bind(newNode))
	
	newNode.disableShortcuts.connect(self.handle_disable_shortcuts)
	newNode.nodeDataEdited.connect(self.handle_node_data_edited.bind(newNode))
	
	newNode.thisNodeAsFocal.connect(self.handle_node_set_itself_focal.bind(newNode))
	newNode.thisNodeAsPinned.connect(self.handle_node_set_itself_pinned.bind(newNode))
	

	newNode.set_position(spawnPos-newNode.size/2)	

	add_child(newNode)
	spawnedNodes[newNode.id] = newNode
	
	# If there is no focalNode, the first node created will become that.	
	if not focalNode:
		setAsFocal(newNode)
		newNode.setAsFocal(focalNode.id)
	
	return newNode



func createEdge(source, target) -> EdgeViewBase:
	if source.id == target.id:
		return
	
	var newEdgeData = dataAccess.addEdge(source.id, target.id)
	
	source.dataNode.addEdge(target.id, newEdgeData.id)
	target.dataNode.addEdge(source.id, newEdgeData.id)
	
	newEdgeData.addSource(source.id, source.position)
	newEdgeData.addTarget(target.id, target.position)
	newEdgeData.setSourcePosition(target.id, source.position, target.position)
	newEdgeData.setTargetPosition(source.id, source.position, target.position)	

	dataAccess.saveEdgeUsingResources(newEdgeData)

#	source.dataNode.setRelatedNodePosition(target.id, source.position, target.position)
#	target.dataNode.setRelatedNodePosition(source.id, target.position, source.position)

		
	dataAccess.saveData()
	var newEdge = spawnEdge(newEdgeData)
	return newEdge

func spawnEdge(newEdgeData: EdgeBase) -> EdgeViewBase:
	if !spawnedNodes.keys().has(newEdgeData.sourceId) or !spawnedNodes.keys().has(newEdgeData.targetId):
		return
	
	var newEdge: EdgeViewBase = edgeBaseTemplate.instantiate()
	newEdge.id = newEdgeData.id
	newEdge.source = spawnedNodes[newEdgeData.sourceId]
	newEdge.target = spawnedNodes[newEdgeData.targetId]
	
	spawnedEdges[str(newEdge.id)] = newEdge

	add_child(newEdge)
	return newEdge



func saveRelativePositions():
	if focalNode != null:

		for relatedId in focalNode.dataNode.edges.keys():
			#var relatedDataNode: NodeBase = spawnedNodes[related].dataNode
			if pinnedNodes.keys().has(relatedId):
				return

#			focalNode.dataNode.setRelatedNodePosition(relatedId, focalNode.position, spawnedNodes[int(relatedId)].position)
			dataAccess.edges[focalNode.dataNode.edges[relatedId]].setConnectionPosition( \
				focalNode.id, focalNode.position, spawnedNodes[int(relatedId)].position)

			#dataAccess.updateEdgeRelativePosition()
	
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
		saveRelativePositions()
	
	node.setAsFocal(node.id)
	focalNode = node
	
	var toBeDespawned = findSpawnedToDespawn(node.dataNode.edges, spawnedNodes)
	despawnNodes(toBeDespawned)
	
	var toBeSpawned = findUnspawnedRelatedNodes(focalNode, spawnedNodes, dataAccess)
	spawnNodes(toBeSpawned)
	

	# Move spawned related nodes to new positions and reset the counter at the end
	for n in spawnedNodes.values():
		if n.id == focalNode.id:
			continue
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
	
func spawnNodes(toBeSpawned):
	for n in toBeSpawned:
		spawnNode(n)
		
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
						
func updateRelativePosition(node):
	pass

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

	if event.is_action_released("dragEdge"):
		if nodeEdgeSource and nodeHovering:
			createEdge(nodeEdgeSource, nodeHovering)
			nodeHovering = null
		elif nodeEdgeSource and socketHovering:
			var newEdge = createEdge(nodeEdgeSource, socketHovering.get_parent())
			socketHovering.addConnection(newEdge.id)
			socketHovering = null
		
		
		nodeEdgeSource = null
		
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
				print("CLICKING SETS THE FOCAL")
				setAsFocal(node)
				
			_:
				pass
	
	if event.is_action_released("mouseLeft"):
		node.nodeMoving = false
		saveOnNodeMoved(node)
	
	if event.is_action_pressed("delete"):
		deleteNode(node)
		

func handle_node_mouse_entered(node):
	pass
func handle_node_mouse_exited(node):
	pass

func handle_disable_shortcuts(disable: bool):
	shortcutsDisabled = disable
func handle_node_data_edited(node: NodeViewBase):
	print("Node edited, trying to save")
	dataAccess.saveNodeUsingResources(node.dataNode)

func saveOnNodeMoved(node):
	var edgeId
	if node != focalNode:
		dataAccess.edges[node.dataNode.edges[focalNode.id]].setConnectionPosition(focalNode.id, focalNode.position, node.position)
	elif node == focalNode:
		saveRelativePositions()

func handle_node_click(node):
	pass
	
func handle_new_edge_drag(node):
	nodeEdgeSource = node

func handle_mouse_hover(node):
	if nodeEdgeSource:
		nodeHovering = node

func handle_node_set_itself_focal(newFocalId):
	setAsFocal(spawnedNodes[newFocalId.id])
		
func handle_node_set_itself_pinned(node):
	setAsPinned(node.id)
	
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
	saveRelativePositions()
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
	shortcutsDisabled = false
