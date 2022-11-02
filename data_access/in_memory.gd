class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var lastId: int = 0

var wires: Array[WireBase] = []


func addNode():
	lastId += 1
	var newNode = NodeBase.new(lastId, "node")
	nodes[lastId] = newNode
	return lastId
	
	
func addWire(srcId: int, trgtId: int, distanceVector: Vector2):
	var newWire: WireBase = WireBase.new(srcId, trgtId, distanceVector)
	wires.append(newWire)
	
	
func getAllWires() -> Array[WireBase]:
	return wires 
