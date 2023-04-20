class_name NodeBase
extends Resource

const Enums = preload("res://data_access/enum_node_types.gd")

@export var id: int
@export var time: float
@export var name: String
@export var edges: Dictionary # id -> RelatedNode
@export var nodeType: String


var assignedPositions: int = 0


func _init(
	n_id: int = 0, 
	n_time: float = Time.get_unix_time_from_system(),
	n_name: String = "node", 
	n_rel: Dictionary = {}, 
	n_type: String = "BASE"
	):
		
	self.id = n_id
	self.time = n_time
	self.name = n_name
	self.edges = n_rel
	self.nodeType = n_type
	
	
func setRelatedNodePosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
	assert(edges.has(int(nodeId)), "ERROR related node not found")
	if relatedPos == Vector2.ZERO or relatedPos == null:
		edges[nodeId].relativePosition = Vector2.ZERO
	else:
		edges[nodeId].relativePosition = relatedPos - selfPos
	
func getRelatedNodePosition(nodeId: int, nodePosition: Vector2):
	if !edges.keys().has(nodeId):
		return
	
	if edges[nodeId].relativePosition != Vector2.ZERO:
		return nodePosition + edges[nodeId].relativePosition
	else: 
		assignedPositions += 1
		return nodePosition + Vector2(0, 150 * assignedPositions)	
		
func addRelatedNode(relatedId: int, relativePos: Vector2 = Vector2.ZERO):
	edges[relatedId] = RelatedNode.new(relatedId, relativePos)

		
func getRelatedNode(relatedId: int) -> RelatedNode: 
	return edges[relatedId]
	
func updateRelatedNode(u_id: int, u_position: Vector2):
	assert(edges.has(u_id), "ERROR related node not found")
	var relatedNode: RelatedNode = edges[u_id]
	relatedNode.relativePosition = u_position
