class_name DataAccessInMemory
extends DataAccess

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBase
var wires: Dictionary = {} # id -> WireBase
var lastNodeId: int = 0
var lastWireId: int = 0

var save_path := "res://data_access/node_data.json"

var defaultSettings: Dictionary = {
	"lastNodeId": 0,
	"lastWireId": 0
}

func loadData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		return {
			"settings": defaultSettings, 
			"nodes": {}, 
			"wires": {}
		}
		
	print("file found")
		
	var file = FileAccess.open(save_path, FileAccess.READ)

	var json = JSON.new()
	
	# Important but annoying as F detail:
	# Json seems to import numbers automatically as floats. Be sure to convert
	# them to int if required.
	
	var loaded = JSON.parse_string(file.get_as_text())
	
	var foundSettings: Dictionary
	var foundNodes: Array[Dictionary]
	var foundWires: Array[Dictionary]
	
	if typeof(loaded) == TYPE_DICTIONARY and "settings" in loaded and "nodes" in loaded and "wires" in loaded:
		print("IS DICTIONARY")
		foundSettings = loaded["settings"]
		foundNodes = loaded["nodes"]
		foundWires = loaded["wires"]
	else:
		foundSettings = defaultSettings
		foundNodes = []
		foundWires = []
	
	lastNodeId = foundSettings["lastNodeId"]
	lastWireId = foundSettings["lastWireId"]
	
	for inode in foundNodes:
		if foundNodes.is_empty():
			break
		
		var loadedId: int
		var loadedName: String
		var loadedRelated = {}
		var loadedType: String
		
		if inode.has("id") and inode.has("name") and inode.has("relatedNodes") and inode.has("nodeType"):
			assert(typeof(inode["relatedNodes"]) == TYPE_DICTIONARY, "ERROR: relatedNodes is not a dictionary.")
			loadedId = inode["id"]
			loadedName = inode["name"]
			loadedType = Enums.NodeTypes.keys()[inode["nodeType"]]
			for rel in inode["relatedNodes"].values():
				var loadedRel = RelatedNode.new(int(rel["id"]), Vector2(rel["relativePositionX"], rel["relativePositionY"]))
				loadedRelated[int(rel["id"])] = loadedRel
			
			loadNode(loadedId, loadedName, loadedRelated, loadedType)
			
			
	for iwire in foundWires:
		if foundWires.is_empty():
			break
		
		var loadedId: int
		var loadedSource: int
		var loadedTarget: int
		if iwire.has("id") and iwire.has("sourceId") and iwire.has("targetId"):
			loadedId = iwire["id"]
			loadedSource = iwire["sourceId"]
			loadedTarget = iwire["targetId"]
			loadWire(loadedId, loadedSource, loadedTarget)
			
	print("NODES" + str(nodes))
	print("WIRES" + str(wires))
		
func loadNode(loadedId: int, loadedName: String, loadedRelated, loadedType: String) -> NodeBase:
	var loadedNode: NodeBase = NodeBase.new(loadedId, loadedName, loadedRelated, loadedType)
	nodes[loadedId] = loadedNode
	
	return loadedNode

	
func loadWire(wid, srcWid, trgtWid) -> WireBase:
	var loadedWire: WireBase = WireBase.new(wid, srcWid, trgtWid)
	wires[wid] = loadedWire
	
	return loadedWire
	
func saveData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		
	var settingsToBeSaved: Dictionary = {}
	var nodesToBeSaved: Array[Dictionary] = []
	var wiresToBeSaved: Array[Dictionary] = []
	
	settingsToBeSaved["lastNodeId"] = lastNodeId
	settingsToBeSaved["lastWireId"] = lastWireId
	
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
				"targetId": c.targetId
			}
			
			wiresToBeSaved.append(wireDict)
	
	print("NODE ARRAY SIZE:" + nodesToBeSaved.size())
	
	var json = JSON.new()
		
	#var save_game = FileAccess.open(savePath, FileAccess.WRITE)
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	var json_nodes = json.stringify({"settings": settingsToBeSaved, "nodes": nodesToBeSaved, "wires": wiresToBeSaved})

	file.store_line(json_nodes)
	print("JSON NODES: " + json_nodes)
	#save_game.close()

func addNode(nodeType: String = "BASE") -> NodeBase:
	lastNodeId += 1
	var newNode: NodeBase = NodeBase.new(lastNodeId, "node", {}, nodeType)
	nodes[lastNodeId] = newNode
	return newNode

func addWire(srcId: int, trgtId: int) -> WireBase:
	lastWireId += 1
	var newWire: WireBase = WireBase.new(lastWireId, srcId, trgtId)
	wires[str(lastWireId)] = newWire
	return newWire
	
func getNode(id: int) -> NodeBase: 
	print("LOOKING FOR " + str(id) + " NODE IN " + str(nodes.keys()) + "(claims "+ str(nodes.has(id)) + ")")
	print(str(nodes[id]))
	assert(nodes.has(id), "ERROR node not found")
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

func getAllWires() -> Dictionary:
	return wires 

func deleteAll():
	nodes = {}
	wires = {}
	saveData()
