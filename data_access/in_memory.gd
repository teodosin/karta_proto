class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var lastId: int = 0

func addNode():
	lastId += 1
	var newNode = {
		"id": lastId,
		"name": "node"
	}
	nodes[lastId] = newNode
	return lastId
	
	
func addWire(fromId: int, toId: int):
	pass
