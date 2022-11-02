class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var lastId: int = 0

var wires: Array[WireBase] = []


func addNode(position: Vector2):
	lastId += 1
	var newNode = NodeBase.new(lastId, "node", position)
	nodes[lastId] = newNode
	return lastId
	
	
func updateNodePosition(id: int, position: Vector2):
	assert(nodes.has(id), "ERROR node not found")
	nodes[id].position = position
	
	
func addWire(srcId: int, trgtId: int, distanceVector: Vector2):
	var newWire: WireBase = WireBase.new(srcId, trgtId, distanceVector)
	wires.append(newWire)
	
	
func getAllWires() -> Array[WireBase]:
	return wires 
