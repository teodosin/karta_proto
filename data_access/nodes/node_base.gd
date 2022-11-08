class_name NodeBase

var id: int
var name: String
var relatedNodes = {} # id -> NodeBase

var assignedPositions: int = 0


func _init(n_id: int, n_name: String):
	self.id = n_id
	self.name = n_name
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
	
	
func updateRelatedNode(u_id: int, u_position: Vector2):
	assert(relatedNodes.has(u_id), "ERROR related node not found")
	var relatedNode: RelatedNode = relatedNodes[u_id]
	relatedNode.relativePosition = u_position
