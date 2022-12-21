class_name DataAccessInMemory
extends DataAccess

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBase
var wires: Dictionary = {} # id -> WireBase
var lastId: int = 0


#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# The data of different node types is also loaded in this file.
# Is this the proper way to go about this?
var textData: Dictionary = {} # id -> NodeText
var imageData: Dictionary = {} # id --> NodeImage
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


var backup_save_path := "res://data_access/node_data_backups.json"
var save_path := "user://node_data.json"

var defaultSettings: Dictionary = {
	"lastId": 0
}

func loadData():

	
	if not FileAccess.file_exists(backup_save_path) and not FileAccess.file_exists(save_path):
		print("File does not exist.")

		return {
			"settings": defaultSettings, 
			"nodes": {}, 
			"wires": {},
			
#vvvvvvvvvvvvvvvvv
			"textData": {},
			"imageData": {}
#^^^^^^^^^^^^^^^^^ 
		}
	var file
	
	if not FileAccess.file_exists(save_path) and FileAccess.file_exists(backup_save_path):
		print("File does not exist. Starting from defaults.")
		file = FileAccess.open(backup_save_path, FileAccess.READ)
	else:
		file = FileAccess.open(save_path, FileAccess.READ)
		print("file found")
		
	# This variable may be unnecessary
	var _json = JSON.new()
	
	# Important but annoying as F detail:
	# Json seems to import numbers automatically as floats. Be sure to convert
	# them to int if required.
	
	var loaded = JSON.parse_string(file.get_as_text())
	
	var foundSettings: Dictionary
	var foundNodes: Array[Dictionary]
	var foundWires: Array[Dictionary]
	
#vvvvvvvvvvvvvvvvvvvvvvv
	var foundText: Array[Dictionary]
	var foundImages: Array[Dictionary]
#^^^^^^^^^^^^^^^^^^^^^^^
	
	if typeof(loaded) == TYPE_DICTIONARY and "settings" in loaded and "nodes" in loaded and "wires" in loaded:
		print("IS DICTIONARY")
		foundSettings = loaded["settings"]
		foundNodes = loaded["nodes"]
		foundWires = loaded["wires"]
	else:
		foundSettings = defaultSettings
		foundNodes = []
		foundWires = []
	
	
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	if typeof(loaded) == TYPE_DICTIONARY and "textData" in loaded and "imageData" in loaded:
		foundText = loaded["textData"]
		foundImages = loaded["imageData"]
	else:
		foundText = []
		foundImages = []
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
	lastId = foundSettings["lastId"]

	
	for inode in foundNodes:
		if foundNodes.is_empty():
			break
		
		var loadedId: int
		var loadedTime: float
		var loadedName: String
		var loadedRelated = {}
		var loadedType: String
		
		if inode.has("id") \
			#and inode.has("time") \
			and inode.has("name") \
			and inode.has("relatedNodes") \
			and inode.has("nodeType"):
				
			assert(typeof(inode["relatedNodes"]) == TYPE_DICTIONARY, "ERROR: relatedNodes is not a dictionary.")
			loadedId = inode["id"]
			loadedTime = inode["time"]
			loadedName = inode["name"]
			loadedType = Enums.NodeTypes.keys()[inode["nodeType"]]
			for rel in inode["relatedNodes"].values():
				var loadedRel = RelatedNode.new(int(rel["id"]), Vector2(rel["relativePositionX"], rel["relativePositionY"]))
				loadedRelated[int(rel["id"])] = loadedRel
			
			loadNode(loadedId, loadedTime, loadedName, loadedRelated, loadedType)
			
			
	for iwire in foundWires:
		if foundWires.is_empty():
			break
		
		var loadedId: int
		var loadedSource: int
		var loadedTarget: int
		var loadedType: String
		var loadedGroup: String
		if iwire.has("id") \
		and iwire.has("sourceId") \
		and iwire.has("targetId") \
		and iwire.has("type") \
		and iwire.has("group"):
			loadedId = iwire["id"]
			loadedSource = iwire["sourceId"]
			loadedTarget = iwire["targetId"]
			loadedType = iwire["type"]
			loadedGroup = iwire["group"]
			loadWire(loadedId, loadedSource, loadedTarget, loadedType, loadedGroup)
	
			
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	for itext in foundText:
		if foundText.is_empty():
			break
			
		var loadedId: int
		var loadedSize: Vector2 
		var loadedText: String
		if itext.has("id") and itext.has("nodeSizeX") and itext.has("nodeSizeY") and itext.has("nodeText"):
			loadedId = itext["id"]
			loadedSize = Vector2(itext["nodeSizeX"], itext["nodeSizeY"])
			loadedText = itext["nodeText"]
			loadText(loadedId, loadedSize, loadedText)

	for iimage in foundImages:
		if foundText.is_empty():
			break
			
		var loadedId: int
		var loadedSize: Vector2 
		var loadedPath: String
		if iimage.has("id") and iimage.has("nodeSizeX") and iimage.has("nodeSizeY") and iimage.has("imagePath"):
			loadedId = iimage["id"]
			loadedSize = Vector2(iimage["nodeSizeX"], iimage["nodeSizeY"])
			loadedPath = iimage["imagePath"]
			loadImage(loadedId, loadedSize, loadedPath)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		
		
		
func loadNode(loadedId: int, loadedTime: float, loadedName: String, loadedRelated, loadedType: String) -> NodeBase:
	var loadedNode: NodeBase = NodeBase.new(loadedId, loadedTime, loadedName, loadedRelated, loadedType)
	nodes[loadedId] = loadedNode
	
	return loadedNode

func loadWire(wid: int, srcWid: int, trgtWid: int, type: String, group: String) -> WireBase:
	var loadedWire: WireBase = WireBase.new(wid, srcWid, trgtWid, type, group)
	wires[wid] = loadedWire
	
	return loadedWire
	
	
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
func loadText(tid, tsize, ttext) -> NodeText:
	var loadedText: NodeText = NodeText.new(tid, tsize, ttext)
	textData[tid] = loadedText
	
	return loadedText
func loadImage(iid, isize, ipath) -> NodeImage:
	var loadedImage: NodeImage = NodeImage.new(iid, isize, ipath)
	imageData[iid] = loadedImage
	
	return loadedImage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
	
func saveData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		
	var settingsToBeSaved: Dictionary = {}
	var nodesToBeSaved: Array[Dictionary] = []
	var wiresToBeSaved: Array[Dictionary] = []
	
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	var textToBeSaved: Array[Dictionary] = []
	var imagesToBeSaved: Array[Dictionary] = []
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
	settingsToBeSaved["lastId"] = lastId
	
	for c in nodes.values():
		if (c is NodeBase):
			var related: Dictionary = {}
			
			for rel in c.relatedNodes.values():
				var relatedDict = {
					"id": rel.id,
					"relativePositionX": rel.relativePosition.x,
					"relativePositionY": rel.relativePosition.y
				}
				related[rel.id] = relatedDict
			
			var nodeDict = {
				"id": c.id,
				"time": c.time,
				"name": c.name,
				"relatedNodes": related,
				"nodeType": Enums.NodeTypes[c.nodeType]
			}
			
			nodesToBeSaved.append(nodeDict)
			
	for c in wires.values():
		if (c is WireBase):
			var wireDict = {
				"id": c.id,
				"sourceId": c.sourceId,
				"targetId": c.targetId,
				"type": c.wireType,
				"group": c.wireGroup
			}
			
			wiresToBeSaved.append(wireDict)
			
			
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	for c in textData.values():
		if c is NodeText:
			var textDict = {
				"id": c.nodeId,
				"nodeSizeX": c.nodeSize.x,
				"nodeSizeY": c.nodeSize.y,
				"nodeText": c.nodeText
			}
			textToBeSaved.append(textDict)
			
	for c in imageData.values():
		if c is NodeImage:
			var imageDict = {
				"id": c.nodeId,
				"nodeSizeX": c.nodeSize.x,
				"nodeSizeY": c.nodeSize.y,
				"imagePath": c.imagePath
			}
			imagesToBeSaved.append(imageDict)
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	

	print("NODE ARRAY SIZE:", nodesToBeSaved.size())
	
	var json = JSON.new()
		
	#var save_game = FileAccess.open(savePath, FileAccess.WRITE)
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	var json_nodes = JSON.stringify({
		"settings": settingsToBeSaved, 
		"nodes": nodesToBeSaved, 
		"wires": wiresToBeSaved,
		
		"textData": textToBeSaved, 
		"imageData": imagesToBeSaved	
	})

	file.store_line(json_nodes)

func addNode(nodeType: String = "BASE") -> NodeBase:
	lastId += 1
	var newNode: NodeBase = NodeBase.new(lastId, Time.get_unix_time_from_system(), "node", {}, nodeType)
	nodes[lastId] = newNode
	
	match nodeType:
		"TEXT":
			var newText: NodeText = NodeText.new(lastId, Vector2(0.0,0.0), "")
			textData[lastId] = newText
		"IMAGE":
			var newImage: NodeImage = NodeImage.new(lastId, Vector2(0.0,0.0), "")
			imageData[lastId] = newImage
			
			
	return newNode

func addWire(srcId: int, trgtId: int, type: String = "BASE", group: String = "none") -> WireBase:
	lastId += 1
	var newWire: WireBase = WireBase.new(lastId, srcId, trgtId, type, group)
	wires[lastId] = newWire
	return newWire
	
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

func getAllWires() -> Dictionary:
	return wires 

func deleteNode(nodeId: int):
	nodes.erase(nodeId)
	textData.erase(nodeId)
	imageData.erase(nodeId)
	for w in wires.values():
		print("ID: " + str(w.id) + " | SRC: " + str(w.sourceId) + " | TRGT: " + str(w.targetId))
		
		print(str(wires))
		
		if w.sourceId == nodeId:
			nodes[w.targetId].relatedNodes.erase(w.sourceId)
			print(str(wires.erase(w.id)) + " was the result of deletion")
		elif w.targetId == nodeId:
			nodes[w.sourceId].relatedNodes.erase(w.targetId)
			print(str(wires.erase(w.id)) + " was the result of deletion")
			
	saveData()

func deleteAll():
	nodes = {}
	wires = {}
	saveData()
