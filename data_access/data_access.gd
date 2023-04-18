extends Node

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBaseData
var wires: Dictionary = {} # id -> WireBaseData
var lastId: int = 0


#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
# The data of different node types is also loaded in this file.
# Is this the proper way to go about this?
var textData: Dictionary = {} # id -> NodeTextData
var imageData: Dictionary = {} # id --> NodeImageData
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


var vault_path := "user://karta_vault"
var nodes_path := "/nodes"
var edges_path := "/edges"

var defaultSettings: Dictionary = {
	"lastId": 0
}

func getNewId():
	lastId += 1
	return lastId

func loadData():
	pass
	
func loadNodeDataById(nodeId: int):
	ResourceLoader.load(vault_path + nodes_path + "/" + str(nodeId) + ".tres")
			
		
#func loadNode(loadedId: int, loadedTime: float, loadedName: String, loadedRelated, loadedType: String) -> NodeBaseData:
#	var loadedNode: NodeBaseData = NodeBaseData.new(loadedId, loadedTime, loadedName, loadedRelated, loadedType)
#	nodes[loadedId] = loadedNode
#
#	return loadedNode
#
#func loadWire(wid: int, srcWid: int, trgtWid: int, type: String, group: String) -> WireBaseData:
#	var loadedWire: WireBaseData = WireBaseData.new(wid, srcWid, trgtWid, type, group)
#	wires[wid] = loadedWire
#
#	return loadedWire
#
	
#vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#func loadText(tid, tsize, ttext) -> NodeTextData:
#	var loadedText: NodeTextData = NodeTextData.new(tid, tsize, ttext)
#	textData[tid] = loadedText
#
#	return loadedText
#func loadImage(iid, isize, ipath) -> NodeImageData:
#	var loadedImage: NodeImageData = NodeImageData.new(iid, isize, ipath)
#	imageData[iid] = loadedImage
#
#	return loadedImage
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
	
func saveData():
	pass
	
func saveNodeData(nodeId: int, nodeData: NodeBaseData):
	var save_path: String = vault_path + nodes_path + str(nodeId) + ".tres"
	
	ResourceSaver.save(nodeData, save_path)


#func addNode(nodeType: String = "BASE") -> NodeBaseData:
#	lastId += 1
#	var newNode: NodeBaseData = NodeBaseData.new(lastId, Time.get_unix_time_from_system(), "node", {}, nodeType)
#	nodes[lastId] = newNode
#
#	match nodeType:
#		"TEXT":
#			var newText: NodeTextData = NodeTextData.new(lastId, Vector2(0.0,0.0), "")
#			textData[lastId] = newText
#		"IMAGE":
#			var newImage: NodeImageData = NodeImageData.new(lastId, Vector2(0.0,0.0), "")
#			imageData[lastId] = newImage
#
#	return newNode

#func addWire(srcId: int, trgtId: int, type: String = "BASE", group: String = "none") -> WireBaseData:
#	lastId += 1
#	var newWire: WireBaseData = WireBaseData.new(lastId, srcId, trgtId, type, group)
#	wires[lastId] = newWire
#	return newWire
#
#func getNode(id: int) -> NodeBaseData: 
#	#print("LOOKING FOR " + str(id) + " NODE IN " + str(nodes.keys()) + "(claims "+ str(nodes.has(id)) + ")")
#	#print(str(nodes[id]))
#	assert(nodes.has(id), "ERROR node not found")
#	return nodes[id]
	
#func getTypeData(id: int):
#	match nodes[id].nodeType:
#		"TEXT": 
#			if textData.keys().has(id):
#				return textData[id]
#		"IMAGE":
#			if imageData.keys().has(id):
#				return imageData[id]

#func updateRelatedNodePosition(id: int, relatedId: int, selfPos: Vector2, relatedPos: Vector2):
#	assert(nodes.has(id), "ERROR node not found")
#	var node: NodeBaseData = nodes[id] 
#	assert(node.relatedNodes.keys().has(relatedId), "ERROR related node not found")
#	node.setRelatedNodePosition(relatedId, selfPos, relatedPos)
#
#func addRelatedNode(id: int, relatedId: int, selfPos, relatedPos: Vector2):
#	assert(nodes.has(id), "ERROR node not found")
#	var node: NodeBaseData = nodes[id]
#
#	node.addRelatedNode(relatedId, selfPos - relatedPos)
#
#func getAllWires() -> Dictionary:
#	return wires 
#
#func deleteNode(nodeId: int):
#	nodes.erase(nodeId)
#	textData.erase(nodeId)
#	imageData.erase(nodeId)
#	for w in wires.values():
#		print("ID: " + str(w.id) + " | SRC: " + str(w.sourceId) + " | TRGT: " + str(w.targetId))
#
#		print(str(wires))
#
#		if w.sourceId == nodeId:
#			nodes[w.targetId].relatedNodes.erase(w.sourceId)
#			print(str(wires.erase(w.id)) + " was the result of deletion")
#		elif w.targetId == nodeId:
#			nodes[w.sourceId].relatedNodes.erase(w.targetId)
#			print(str(wires.erase(w.id)) + " was the result of deletion")
#
#	saveData()
#
#func deleteAll():
#	nodes = {}
#	wires = {}
#	saveData()
