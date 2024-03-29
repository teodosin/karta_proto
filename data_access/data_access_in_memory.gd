class_name DataAccessInMemory
extends DataAccess

var sceneObjectRectangle = preload("res://data_access/node_types/objects/object_rectangle.tscn")

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBase
var edges: Dictionary = {} # id -> EdgeBase

var settings: KartaSettings

#The following will be the paths for the resource saving
var vault_path := "user://karta_vault/"
var settings_path := "settings/"

var nodes_path := "nodes/"
var edges_path := "edges/"

#var defaultSettings: Dictionary = {
#	"lastId": 0
#}

func init_vault():
	if not DirAccess.dir_exists_absolute(vault_path):
		DirAccess.make_dir_absolute(vault_path)
	if not DirAccess.dir_exists_absolute(vault_path + settings_path):
		DirAccess.make_dir_absolute(vault_path + settings_path)
		
	if not DirAccess.dir_exists_absolute(vault_path + nodes_path):
		DirAccess.make_dir_absolute(vault_path + nodes_path)
	if not DirAccess.dir_exists_absolute(vault_path + edges_path):
		DirAccess.make_dir_absolute(vault_path + edges_path)
		
	if not DirAccess.dir_exists_absolute(vault_path + settings_path):
		DirAccess.make_dir_absolute(vault_path + settings_path)


func loadData():
	init_vault()
	
	loadSettings()
	
	# Start from where the user left off
	# loadNodeUsingResources(settings.lastFocalId)
	
	loadNodesUsingResources()
	loadEdgesUsingResources()


func loadSettings():
	var filePath: String = vault_path + settings_path + "settings.tres"
	if not FileAccess.file_exists(filePath):
		var newSettings = KartaSettings.new()
		ResourceSaver.save(newSettings, vault_path + settings_path + "settings.tres")
		settings = newSettings
	else:
		var loadedSettings: KartaSettings = ResourceLoader.load(filePath, "KartaSettings")
		settings = loadedSettings


func loadEdgesUsingResources():
	var dir = DirAccess.open(vault_path + edges_path)
	
	var loadedEdge: EdgeBase
	
	for file in dir.get_files():
		var filePath: String = vault_path + edges_path + file
		loadedEdge = ResourceLoader.load(filePath, "EdgeBase")
		edges[loadedEdge.id] = loadedEdge
		
	if edges.size() != 0:
		var firstRel = edges[edges.keys()[0]]
		assert("sourceRelativeData" in firstRel)
		assert("relativePosition" in firstRel.sourceRelativeData)
		
func loadEdgeUsingResources(edgeId):
	var filePath: String = vault_path + edges_path + str(edgeId) + ".tres"
	var loadedEdge: EdgeBase = ResourceLoader.load(filePath, "EdgeBase")
	edges[loadedEdge.id] = loadedEdge
	return loadedEdge

func loadNodesUsingResources():
	var dir = DirAccess.open(vault_path + nodes_path)
	
	for file in dir.get_files():
		# The file string includes the file extension, so converting into 
		# an int is ugly but seems to work. Clean-up would be nice, but not urgent.
		loadNodeUsingResources(int(file))

func loadFirstNode():
	var dir = DirAccess.open(vault_path + nodes_path)
	
	for file in dir.get_files():
		# The file string includes the file extension, so converting into 
		# an int is ugly but seems to work. Clean-up would be nice, but not urgent.
		return loadNodeUsingResources(int(file))
		
		
func loadNodeConnections(nodeId:int):
	if !nodes.has(nodeId):
		loadNodeUsingResources(nodeId)
	
	var thisNode = nodes[nodeId]
	
	for edge in thisNode.edges.keys():
		loadNodeUsingResources(edge)
		loadEdgeUsingResources(thisNode.edges[edge])
	

func loadNodeUsingResources(nodeId: int) -> NodeBase:
	var filePath: String = vault_path + nodes_path + str(nodeId) + ".tres"
	if !FileAccess.file_exists(filePath):
		print("No file found. Returning.")
		loadFirstNode()
		return
	
	var loadedNode: NodeBase = ResourceLoader.load(filePath, "NodeBase")
	nodes[loadedNode.id] = loadedNode
	return loadedNode


func saveSettings():
	var savePath: String = vault_path + settings_path + "settings.tres"
	ResourceSaver.save(settings, savePath)
	
func setLastFocalId(focalId: int):
	settings.lastFocalId = focalId
	saveSettings()

func saveAllNodesUsingResources():

	for c in nodes.values():
		if (c is NodeBase):
			saveNodeUsingResources(c)
			
func saveNodeUsingResources(node: NodeBase):
	var save_path: String = vault_path + nodes_path + str(node.id) + ".tres"
	
	# ResourceSaver.save(node, save_path)


func saveAllEdgesUsingResources():
	for c in edges.values():
		if (c is EdgeBase):
			saveEdgeUsingResources(c)
			
func saveEdgeUsingResources(edge: EdgeBase):
	var save_path: String = vault_path + edges_path + str(edge.id) + ".tres"
	ResourceSaver.save(edge, save_path)
	
	
func deleteAllNodeResources():
	var del_path: String = vault_path + nodes_path
	for file in DirAccess.get_files_at(del_path):
		DirAccess.remove_absolute(del_path + file)
	
func deleteAllEdgeResources():
	var del_path: String = vault_path + edges_path
	for file in DirAccess.get_files_at(del_path):
		DirAccess.remove_absolute(del_path + file)
	
func deleteEdgeResource(edgeId: int):
	var del_path: String = vault_path + edges_path + str(edgeId) + ".tres"
	DirAccess.remove_absolute(del_path)
	
func deleteNodeResource(nodeId: int):
	var del_path: String = vault_path + nodes_path + str(nodeId) + ".tres"
	DirAccess.remove_absolute(del_path)
	
	
func saveData():

	saveAllNodesUsingResources()
	saveAllEdgesUsingResources()
	saveSettings()

func addNode(dataType: String = "BASE") -> NodeBase:
	settings.lastId += 1
	var newNode: NodeBase = NodeBase.new(
		settings.lastId, 
		Time.get_unix_time_from_system(), 
		"node", 
		{}, 
		dataType
	)
	nodes[settings.lastId] = newNode
	
	match dataType:
		"TEXT":
			var newText: NodeTypeData = NodeText.new(settings.lastId)
			newNode.typeData = newText
		"IMAGE":
			var newImage: NodeTypeData = NodeImage.new(settings.lastId)
			newNode.typeData = newImage
		"SCENE":
			var newScene: NodeTypeData = NodeScene.new(settings.lastId)
			newNode.typeData = newScene
		"OBJECT_RECTANGLE":
			var newRect: Node2D = sceneObjectRectangle.instantiate()
			newRect.setPosition(Vector2(randf_range(-500.0, 500.0), randf_range(-500.0, 500.0)))
			newRect.setSize(Vector2(randf_range(0.0, 500.0), randf_range(0.0, 500.0)))
			newNode.objectData = newRect
			
			
	saveNodeUsingResources(newNode)
	
	return newNode

func addEdge(srcId: int, trgtId: int, type: String = "BASE", group: String = "none") -> EdgeBase:
	settings.lastId += 1
	var newEdge: EdgeBase = EdgeBase.new(settings.lastId, srcId, trgtId, type, group)
	edges[settings.lastId] = newEdge
	return newEdge
	
func getNode(id: int) -> NodeBase: 

	if !nodes.has(id):
		return loadFirstNode()
	#assert(nodes.has(id), "ERROR node not found")
	
	return nodes[id]
	

func updateRelatedNodePosition(id: int, relatedId: int, selfPos: Vector2, relatedPos: Vector2):
	assert(nodes.has(id), "ERROR node not found")
	var node: NodeBase = nodes[id] 
	assert(node.relatedNodes.keys().has(relatedId), "ERROR related node not found")
	node.setRelatedNodePosition(relatedId, selfPos, relatedPos)
	
func addRelatedNode(id: int, relatedId: int, selfPos, relatedPos: Vector2):
	assert(nodes.has(id), "ERROR node not found")
	var node: NodeBase = nodes[id]

	node.addRelatedNode(relatedId, selfPos - relatedPos)

func getAllEdges() -> Dictionary:
	return edges 

func deleteNode(nodeId: int):
	nodes.erase(nodeId)
	
	
	for w in edges.values():
		if w.sourceId == nodeId:
			nodes[w.targetId].edges.erase(w.sourceId)

		elif w.targetId == nodeId:
			nodes[w.sourceId].edges.erase(w.targetId)

			
		deleteEdgeResource(w.id)
			
	deleteNodeResource(nodeId)
	saveData()

func deleteAll():
	pass
	
	nodes = {}
	edges = {}
	deleteAllNodeResources()
	deleteAllEdgeResources()
	saveData()
