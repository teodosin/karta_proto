class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {} # id -> NodeBase
var wires: Dictionary = {} # id -> WireBase
var lastNodeId: int = 0
var lastWireId: int = 0

var save_path := "res://data_access/node_data.json"

func loadData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		return {"nodes": {}, "wires": {}}
		
	print("file found")
		
	var file = FileAccess.open(save_path, FileAccess.READ)

	var json = JSON.new()
	
	var loaded = json.parse_string(file.get_as_text())
	
	var foundNodes
	var foundWires
	
	if typeof(loaded) == TYPE_DICTIONARY and "nodes" in loaded and "wires" in loaded:
		print("IS DICTIONARY")
		foundNodes = loaded["nodes"]
		foundWires = loaded["wires"]
	else:
		foundNodes = {}
		foundWires = {}
	
	for inode in foundNodes:
		if foundNodes.is_empty():
			break
		
		var loadedId
		var loadedName
		var loadedRelated = {}
		if inode.has("id") and inode.has("name") and inode.has("relatedNodes"):
			assert(typeof(inode["relatedNodes"]) == TYPE_DICTIONARY, "ERROR: relatedNodes is not a dictionary.")
			loadedId = inode["id"]
			loadedName = inode["name"]
			
			for rel in inode["relatedNodes"].values():
				var loadedRel = RelatedNode.new(rel["id"], Vector2(rel["relativePositionX"], rel["relativePositionY"]))
				loadedRelated[rel["id"]] = loadedRel
			
			loadNode(loadedId, loadedName, loadedRelated)
			
			
	for iwire in foundWires:
		if foundWires.is_empty():
			break
		
		var loadedId
		var loadedSource
		var loadedTarget
		if iwire.has("id") and iwire.has("sourceId") and iwire.has("targetId"):
			loadedId = iwire["id"]
			loadedSource = iwire["sourceId"]
			loadedTarget = iwire["targetId"]
			loadWire(loadedId, loadedSource, loadedTarget)
			
	print("NODES" + str(nodes))
	print("WIRES" + str(wires))
		
func loadNode(loadedId, loadedName, loadedRelated) -> NodeBase:
	var loadedNode: NodeBase = NodeBase.new(loadedId, loadedName, loadedRelated)
	nodes[loadedId] = loadedNode
	
	return loadedNode

	
func loadWire(wid, srcWid, trgtWid) -> WireBase:
	var loadedWire: WireBase = WireBase.new(wid, srcWid, trgtWid)
	wires[wid] = loadedWire
	
	return loadedWire
	
func saveData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		
	var nodesToBeSaved = []
	var wiresToBeSaved = []
	
	for c in nodes.values():
		if (c is NodeBase):
			var related = {}
			
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
				"relatedNodes": related
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
	var json_nodes = json.stringify({"nodes": nodesToBeSaved, "wires": wiresToBeSaved})

	file.store_line(json_nodes)
	print("JSON NODES: " + json_nodes)
	#save_game.close()

func addNode() -> NodeBase:
	lastNodeId += 1
	var newNode: NodeBase = NodeBase.new(lastNodeId, "node", {})
	nodes[lastNodeId] = newNode
	return newNode

func addWire(srcId: int, trgtId: int) -> WireBase:
	lastWireId += 1
	var newWire: WireBase = WireBase.new(lastWireId, srcId, trgtId)
	wires[str(lastWireId)] = newWire
	return newWire
	
func getNode(id: int) -> NodeBase: 
	assert(nodes.keys().has(id), "ERROR node not found")
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
