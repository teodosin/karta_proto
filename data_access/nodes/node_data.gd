class_name NodeBase

const Enums = preload("res://data_access/enum_node_types.gd")

var id: int
var time: float
var name: String
var relatedNodes: Dictionary # id -> RelatedNode
var nodeType: String


var assignedPositions: int = 0


func _init(
	n_id: int, 
	n_time: float = Time.get_unix_time_from_system(),
	n_name: String = "node", 
	n_rel: Dictionary = {}, 
	n_type: String = "BASE"
	):
		
	self.id = n_id
	self.time = n_time
	self.name = n_name
	self.relatedNodes = n_rel
	self.nodeType = n_type
	
	
func setRelatedNodePosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
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
