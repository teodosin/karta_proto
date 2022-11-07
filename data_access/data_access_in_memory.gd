class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var wires: Dictionary = {}
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
		addNode()
	for iwire in foundWires:
		addWire

	
func saveData():
	if not FileAccess.file_exists(save_path):
		print("File does not exist")
		
	print("saving file")
	
	var json = JSON.new()
		
	#var save_game = FileAccess.open(savePath, FileAccess.WRITE)
	var file = FileAccess.open(save_path,FileAccess.WRITE)
	var json_nodes = json.stringify({"nodes": {}, "wires": {}})

	file.store_line(json_nodes)
	print(json_nodes)
	#save_game.close()

func addNode() -> NodeBase:
	lastNodeId += 1
	var newNode: NodeBase = NodeBase.new(lastNodeId, "node")
	nodes[lastNodeId] = newNode
	return newNode

func addWire(srcId: int, trgtId: int) -> WireBase:
	lastWireId += 1
	var newWire: WireBase = WireBase.new(lastWireId, srcId, trgtId)
	wires[str(lastWireId)] = newWire
	return newWire
	
func getNode(id: int) -> NodeBase: 
	assert(nodes.has(id), "ERROR node not found")
	return nodes[id]
	
func updateRelatedNodePosition(id: int, relatedId: int, position: Vector2):
	assert(nodes.has(id), "ERROR node not found")
	var node: NodeBase = nodes[id] 
	assert(node.relatedNodes.has(relatedId), "ERROR related node not found")
	var relatedNode: RelatedNode = nodes.relatedNodes[relatedId]
	relatedNode.position = position
	
func addRelatedNode(id: int, relatedId: int, relatedPosition: Vector2):
	assert(nodes.has(id), "ERROR node not found")
	var node: NodeBase = nodes[id]
	var newRelatedNode: RelatedNode = RelatedNode.new(relatedId, node.position - relatedPosition)
	

	
func getAllWires() -> Dictionary:
	return wires 
