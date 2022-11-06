class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var lastId: int = 0

var wires: Array[WireBase] = []


func addNode() -> NodeBase:
	lastId += 1
	var newNode: NodeBase = NodeBase.new(lastId, "node")
	nodes[lastId] = newNode
	return newNode
	
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
	
func addWire(srcId: int, trgtId: int):
	var newWire: WireBase = WireBase.new(srcId, trgtId)
	wires.append(newWire)
	
	
func getAllWires() -> Array[WireBase]:
	return wires 
