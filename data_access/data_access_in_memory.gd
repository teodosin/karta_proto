class_name DataAccessInMemory
extends DataAccess

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBase
var edges: Dictionary = {} # id -> EdgeBase

var settings: KartaSettings

#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
var textData: Dictionary = {} # id -> NodeText
var imageData: Dictionary = {} # id --> NodeImage
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#var nodes: Dictionary = {}
#var edges: Dictionary = {}

# Paths for JSON saving, will soon be deprecated
var backup_save_path := "res://data_access/node_data_backups.json"
var save_path := "user://node_data.json"

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
#	if not FileAccess.file_exists(backup_save_path) and not FileAccess.file_exists(save_path):
#		print("File does not exist.")
#
#		return {
#			"settings": defaultSettings, 
#			"nodes": {}, 
#			"edges": {},
#
##vvvvvvvvvvvvvvvvv
#			"textData": {},
#			"imageData": {}
##^^^^^^^^^^^^^^^^^ 
#		}
#
	init_vault()
	
#	var file
#
#	if not FileAccess.file_exists(save_path) and FileAccess.file_exists(backup_save_path):
#		print("File does not exist. Starting from defaults.")
#		file = FileAccess.open(backup_save_path, FileAccess.READ)
#	else:
#		file = FileAccess.open(save_path, FileAccess.READ)
#		print("file found")
#
#	# This variable may be unnecessary
#	var _json = JSON.new()
#
#	# Important but annoying as F detail:
#	# Json seems to import numbers automatically as floats. Be sure to convert
#	# them to int if required.
#
#	var loaded = JSON.parse_string(file.get_as_text())
#
#	var foundSettings: Dictionary
#	var foundNodes: Array
#	var foundEdges: Array
#
##vvvvvvvvvvvvvvvvvvvvvvv
#	var foundText: Array
#	var foundImages: Array
##^^^^^^^^^^^^^^^^^^^^^^^
#
#	if typeof(loaded) == TYPE_DICTIONARY and "settings" in loaded and "nodes" in loaded and "edges" in loaded:
#		print("IS DICTIONARY")
#		foundSettings = loaded["settings"]
#		foundNodes = loaded["nodes"]
#		foundEdges = loaded["edges"]
#	else:
#		foundSettings = defaultSettings
#		foundNodes = []
#		foundEdges = []
#
#
##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#	if typeof(loaded) == TYPE_DICTIONARY and "textData" in loaded and "imageData" in loaded:
#		foundText = loaded["textData"]
#		foundImages = loaded["imageData"]
#	else:
#		foundText = []
#		foundImages = []
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#	lastId = foundSettings["lastId"]

	loadSettings()
	loadNodesUsingResources()
	loadEdgesUsingResources()
#
#	for inode in foundNodes:
#		if foundNodes.is_empty():
#			break
#
#		var loadedId: int
#		var loadedTime: float
#		var loadedName: String
#		var loadedRelated = {}
#		var loadedType: String
#
#		if inode.has("id") \
#			#and inode.has("time") \
#			and inode.has("name") \
#			and inode.has("relatedNodes") \
#			and inode.has("nodeType"):
#
#			assert(typeof(inode["relatedNodes"]) == TYPE_DICTIONARY, "ERROR: relatedNodes is not a dictionary.")
#			loadedId = inode["id"]
#			loadedTime = inode["time"]
#			loadedName = inode["name"]
#			loadedType = Enums.NodeTypes.keys()[inode["nodeType"]]
#			for rel in inode["relatedNodes"].values():
#				var loadedRel = RelatedNode.new(int(rel["id"]), Vector2(rel["relativePositionX"], rel["relativePositionY"]))
#				loadedRelated[int(rel["id"])] = loadedRel
#
#			loadNode(loadedId, loadedTime, loadedName, loadedRelated, loadedType)
#
#	for iedge in foundEdges:
#		if foundEdges.is_empty():
#			break
#
#		var loadedId: int
#		var loadedSource: int
#		var loadedTarget: int
#		var loadedType: String
#		var loadedGroup: String
#		if iedge.has("id") \
#		and iedge.has("sourceId") \
#		and iedge.has("targetId") \
#		and iedge.has("type") \
#		and iedge.has("group"):
#			loadedId = iedge["id"]
#			loadedSource = iedge["sourceId"]
#			loadedTarget = iedge["targetId"]
#			loadedType = iedge["type"]
#			loadedGroup = iedge["group"]
#			loadEdge(loadedId, loadedSource, loadedTarget, loadedType, loadedGroup)
#
#
##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#	for itext in foundText:
#		if foundText.is_empty():
#			break
#
#		var loadedId: int
#		var loadedSize: Vector2 
#		var loadedText: String
#		if itext.has("id") and itext.has("nodeSizeX") and itext.has("nodeSizeY") and itext.has("nodeText"):
#			loadedId = itext["id"]
#			loadedSize = Vector2(itext["nodeSizeX"], itext["nodeSizeY"])
#			loadedText = itext["nodeText"]
#			loadText(loadedId, loadedSize, loadedText)
#
#	for iimage in foundImages:
#		if foundText.is_empty():
#			break
#
#		var loadedId: int
#		var loadedSize: Vector2 
#		var loadedPath: String
#		if iimage.has("id") and iimage.has("nodeSizeX") and iimage.has("nodeSizeY") and iimage.has("imagePath"):
#			loadedId = iimage["id"]
#			loadedSize = Vector2(iimage["nodeSizeX"], iimage["nodeSizeY"])
#			loadedPath = iimage["imagePath"]
#			loadImage(loadedId, loadedSize, loadedPath)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		
		
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
		
	#print("edges are" + str(edges))
	if edges.size() != 0:
		var firstRel = edges[edges.keys()[0]]
		#print(firstRel)
		#print(firstRel.get_property_list())
		assert("sourceRelativeData" in firstRel)
		assert("relativePosition" in firstRel.sourceRelativeData)
		
func loadNodesUsingResources():
	var dir = DirAccess.open(vault_path + nodes_path)
	
	var loadedNode: NodeBase
	
	for file in dir.get_files():
		var filePath: String = vault_path + nodes_path + file
		loadedNode = ResourceLoader.load(filePath, "NodeBase")
		nodes[loadedNode.id] = loadedNode
		

func updateEdgeRelativePosition(edgeId: int, selfId: int, selfPos: Vector2, newPos: Vector2):
	assert(edges.has(edgeId))
	
	edges[edgeId].setConnectionPosition(selfId, selfPos, newPos)
	
	#Autosave after edit edge
	saveEdgeUsingResources(edges[edgeId])
	

func saveSettings():
	var savePath: String = vault_path + settings_path + "settings.tres"
	ResourceSaver.save(settings, savePath)

func saveAllNodesUsingResources():
	print("Trying to SAVE: " + str(nodes.size()))
	for c in nodes.values():
		if (c is NodeBase):
			saveNodeUsingResources(c)
			
func saveNodeUsingResources(node: NodeBase):
	var save_path: String = vault_path + nodes_path + str(node.id) + ".tres"
	
	print("Trying to save the nodeId" + str(node.id) + " to " + save_path)
	
	print(nodes[nodes.keys()[0]])
	
	print(ResourceSaver.save(node, save_path))


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
		print(del_path + file)
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
	
	
	
#func loadNode(loadedId: int, loadedTime: float, loadedName: String, loadedRelated, loadedType: String) -> NodeBase:
#	var loadedNode: NodeBase = NodeBase.new(loadedId, loadedTime, loadedName, loadedRelated, loadedType)
#	nodes[loadedId] = loadedNode
#
#	return loadedNode
#
#func loadEdge(wid: int, srcWid: int, trgtWid: int, type: String, group: String) -> EdgeBase:
#	var loadedEdge: EdgeBase = EdgeBase.new(wid, srcWid, trgtWid, type, group)
#	edges[wid] = loadedEdge
#
#	return loadedEdge
	
	
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#func loadText(tid, tsize, ttext) -> NodeText:
#	var loadedText: NodeText = NodeText.new(tid, tsize, ttext)
#	textData[tid] = loadedText
#
#	return loadedText
#func loadImage(iid, isize, ipath) -> NodeImage:
#	var loadedImage: NodeImage = NodeImage.new(iid, isize, ipath)
#	imageData[iid] = loadedImage
#
#	return loadedImage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
	
func saveData():
#	if not FileAccess.file_exists(save_path):
#		print("File does not exist")
#
#	var settingsToBeSaved: Dictionary = {}
#	var nodesToBeSaved: Array[Dictionary] = []
#	var edgesToBeSaved: Array[Dictionary] = []
#
##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#	var textToBeSaved: Array[Dictionary] = []
#	var imagesToBeSaved: Array[Dictionary] = []
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#	settingsToBeSaved["lastId"] = lastId
	
	saveAllNodesUsingResources()
	saveAllEdgesUsingResources()
	saveSettings()
	
#	for c in nodes.values():
#		if (c is NodeBase):
#			var related: Dictionary = {}
#
#			for rel in c.edges.values():
#				var relatedDict = {
#					"id": rel.id,
#					"relativePositionX": rel.relativePosition.x,
#					"relativePositionY": rel.relativePosition.y
#				}
#				related[rel.id] = relatedDict
#
#			var nodeDict = {
#				"id": c.id,
#				"time": c.time,
#				"name": c.name,
#				"relatedNodes": related,
#				"nodeType": Enums.NodeTypes[c.nodeType]
#			}
#
#			nodesToBeSaved.append(nodeDict)
#
#	for c in edges.values():
#		if (c is EdgeBase):
#			var edgeDict = {
#				"id": c.id,
#				"sourceId": c.sourceId,
#				"targetId": c.targetId,
#				"type": c.edgeType,
#				"group": c.edgeGroup
#			}
#
#			edgesToBeSaved.append(edgeDict)
#
#
##vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#	for c in textData.values():
#		if c is NodeText:
#			var textDict = {
#				"id": c.nodeId,
#				"nodeSizeX": c.nodeSize.x,
#				"nodeSizeY": c.nodeSize.y,
#				"nodeText": c.nodeText
#			}
#			textToBeSaved.append(textDict)
#
#	for c in imageData.values():
#		if c is NodeImage:
#			var imageDict = {
#				"id": c.nodeId,
#				"nodeSizeX": c.nodeSize.x,
#				"nodeSizeY": c.nodeSize.y,
#				"imagePath": c.imagePath
#			}
#			imagesToBeSaved.append(imageDict)
##^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#
#
#	print("NODE ARRAY SIZE:", nodesToBeSaved.size())
#
#	var json = JSON.new()
#
#	#var save_game = FileAccess.open(savePath, FileAccess.WRITE)
#	var file = FileAccess.open(save_path,FileAccess.WRITE)
#	var json_nodes = JSON.stringify({
#		"settings": settingsToBeSaved, 
#		"nodes": nodesToBeSaved, 
#		"edges": edgesToBeSaved,
#
#		"textData": textToBeSaved, 
#		"imageData": imagesToBeSaved	
#	})
#
#	file.store_line(json_nodes)

func addNode(nodeType: String = "BASE") -> NodeBase:
	settings.lastId += 1
	var newNode: NodeBase = NodeBase.new(settings.lastId, Time.get_unix_time_from_system(), "node", {}, nodeType)
	nodes[settings.lastId] = newNode
	
	match nodeType:
		"TEXT":
			var newText: NodeTypeData = NodeText.new(settings.lastId, Vector2(0.0,0.0), "")
			textData[settings.lastId] = newText
			newNode.typeData = newText
		"IMAGE":
			var newImage: NodeTypeData = NodeImage.new(settings.lastId, Vector2(0.0,0.0), "")
			imageData[settings.lastId] = newImage
			newNode.typeData = newImage
			
	saveNodeUsingResources(newNode)
	
	return newNode

func addEdge(srcId: int, trgtId: int, type: String = "BASE", group: String = "none") -> EdgeBase:
	settings.lastId += 1
	var newEdge: EdgeBase = EdgeBase.new(settings.lastId, srcId, trgtId, type, group)
	edges[settings.lastId] = newEdge
	return newEdge
	
func getNode(id: int) -> NodeBase: 
	#print("LOOKING FOR " + str(id) + " NODE IN " + str(nodes.keys()) + "(claims "+ str(nodes.has(id)) + ")")
	#print(str(nodes[id]))
	assert(nodes.has(id), "ERROR node not found")
	return nodes[id]
	
func getTypeData(id: int):
	match nodes[id].nodeType:
		"TEXT": 
			if textData.keys().has(id):
				return textData[id]
		"IMAGE":
			if imageData.keys().has(id):
				return imageData[id]

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
	textData.erase(nodeId)
	imageData.erase(nodeId)
	
	deleteNodeResource(nodeId)
	
	for w in edges.values():
		print("ID: " + str(w.id) + " | SRC: " + str(w.sourceId) + " | TRGT: " + str(w.targetId))
		
		print(str(edges))
		
		if w.sourceId == nodeId:
			nodes[w.targetId].edges.erase(w.sourceId)
			print(str(edges.erase(w.id)) + " was the result of deletion")
		elif w.targetId == nodeId:
			nodes[w.sourceId].edges.erase(w.targetId)
			print(str(edges.erase(w.id)) + " was the result of deletion")
			
		deleteEdgeResource(w.id)
			
	saveData()

func deleteAll():
	nodes = {}
	edges = {}
	deleteAllNodeResources()
	deleteAllEdgeResources()
	saveData()
