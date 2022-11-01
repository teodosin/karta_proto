class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var lastId: int = 0

var wires: Dictionary = {}

func addNode():
	lastId += 1
	var newNode = {
		"id": lastId,
		"name": "node"
	}
	nodes[lastId] = newNode
	return lastId
	
	
func addWire(src: int, trgt: int):
	var newWire: WireBase = WireBase.new()
