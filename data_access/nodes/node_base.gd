class_name NodeBase

var id: int
var name: String
var relatedNodes = {} # id -> NodeBase

var assignedPositions: int = 0


func _init(id: int, name: String):
	self.id = id
	self.name = name
	self.relatedNodes = {}
	
func getRelatedNodePosition(nodeId: int, nodePosition: Vector2) -> Vector2:
	if relatedNodes.has(nodeId):
		return nodePosition + relatedNodes[nodeId]["relativePosition"]
	else: 
		assignedPositions += 1
		return nodePosition + Vector2(0, 150 * assignedPositions)	
	
func getRelatedNode(relatedId: int) -> RelatedNode: 
	assert(relatedNodes.has(relatedId), "ERROR related node not found")
	return relatedNodes[relatedId]
	
	
func addRelatedNode(relatedNode: RelatedNode):
	relatedNodes[relatedNode.id] = relatedNode
	
	
func updateRelatedNode(id: int, position: Vector2):
	assert(relatedNodes.has(id), "ERROR related node not found")
	var relatedNode: RelatedNode = relatedNodes[id]
	relatedNode.relativePosition = position
