extends Node

const Enums = preload("res://data_access/enum_node_types.gd")

var nodes: Dictionary = {} # id -> NodeBaseData
var wires: Dictionary = {} # id -> WireBaseData


var vault_path := "user://karta_vault/"
var settings_path := "settings/"

var nodes_path := "nodes/"
var edges_path := "edges/"

var settings: Settings

func init_vault():
	if not DirAccess.dir_exists_absolute(vault_path):
		DirAccess.make_dir_absolute(vault_path)
	if not DirAccess.dir_exists_absolute(vault_path + settings_path):
		DirAccess.make_dir_absolute(vault_path + settings_path)
		
	if not DirAccess.dir_exists_absolute(vault_path + nodes_path):
		DirAccess.make_dir_absolute(vault_path + nodes_path)
	if not DirAccess.dir_exists_absolute(vault_path + edges_path):
		DirAccess.make_dir_absolute(vault_path + edges_path)
		
	init_settings()
	
func init_settings():
	var settingsDir = DirAccess.open(vault_path+settings_path)
	if not settingsDir.file_exists("settings.tres"):
		print("Settings file does not exist.")
		var newSettings: Settings = Settings.new()
		settings = newSettings
		save_settings()
	else:
		settings = load(vault_path+settings_path+"settings.tres") as Settings
func save_settings():
		ResourceSaver.save(settings, vault_path+settings_path+"settings.tres")
	
		
func getNewId():
	settings.incrementLastId()
	print(settings.getLastId())
	return settings.getLastId()

func loadAllData():
	loadAllNodes()

func loadAllNodes():
	var dir = DirAccess.open(vault_path + nodes_path)
	for file in dir.get_files():
		var loadedNode = load(vault_path + nodes_path + file) as NodeBaseData
		nodes[loadedNode.id] = loadedNode
	
func loadFirstNode():
	assert(DirAccess.dir_exists_absolute(vault_path + nodes_path))
	var dir = DirAccess.open(vault_path + nodes_path)
	
	if dir.get_files().size() == 0:
		print("No nodes found in directory.")
		return
		
	print(dir.get_files()[0])
	var loadedNode = load(vault_path + nodes_path + dir.get_files()[0]) as NodeBaseData
	if loadedNode != null:
		nodes[loadedNode.id] = loadedNode
	
func loadNodeDataById(nodeId: int):
	load(vault_path + nodes_path + str(nodeId) + ".tres") as NodeBaseData

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

func saveEdgeData(edgeId: int, edgeData: WireBaseData):
	var save_path: String = vault_path + edges_path + str(edgeId) + ".tres"
	
	ResourceSaver.save(edgeData, save_path)
	
	
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
