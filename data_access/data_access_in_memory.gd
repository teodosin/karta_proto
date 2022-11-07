class_name DataAccessInMemory
extends DataAccess

var nodes: Dictionary = {}
var wires: Dictionary = {}
var lastNodeId: int = 0
var lastWireId: int = 0



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
