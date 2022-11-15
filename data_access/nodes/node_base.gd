class_name NodeBase

var id: int
var name: String
var relatedNodes = {} # id -> RelatedNode

var assignedPositions: int = 0


func _init(n_id: int, n_name: String, n_rel: Dictionary):
	self.id = n_id
	self.name = n_name
	self.relatedNodes = n_rel
	
func setRelatedNodePosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
	print("TypeOf :)))))" + str(typeof(relatedNodes.keys()[0])) + str(nodeId))
	assert(relatedNodes.has(int(nodeId)), "ERROR related node not found")
	if relatedPos == Vector2.ZERO or relatedPos == null:
		relatedNodes[nodeId].relativePosition = Vector2.ZERO
	else:
		relatedNodes[nodeId].relativePosition = relatedPos - selfPos
	
	
func getRelatedNodePosition(nodeId: int, nodePosition: Vector2):
	if !relatedNodes.keys().has(nodeId):
		return
	
	if relatedNodes[nodeId].relativePosition != Vector2.ZERO:
		return nodePosition + relatedNodes[nodeId].relativePosition
	else: 
		assignedPositions += 1
		return nodePosition + Vector2(0, 150 * assignedPositions)	
		
func addRelatedNode(relatedId: int, relativePos: Vector2 = Vector2.ZERO):
	relatedNodes[relatedId] = RelatedNode.new(relatedId, relativePos)

		
func getRelatedNode(relatedId: int) -> RelatedNode: 
	return relatedNodes[relatedId]
	
	

	
func updateRelatedNode(u_id: int, u_position: Vector2):
	assert(relatedNodes.has(u_id), "ERROR related node not found")
	var relatedNode: RelatedNode = relatedNodes[u_id]
	relatedNode.relativePosition = u_position
