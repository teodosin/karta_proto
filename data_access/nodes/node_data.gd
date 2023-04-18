class_name NodeBaseData
extends Resource

const Enums = preload("res://data_access/enum_node_types.gd")

var id: int
var time: float
var name: String

var nodeSize: Vector2
var nodeRotation: float

var nodeType: String
var typeData: Resource

var edges: Dictionary # id -> WireBaseData

var assignedPositions: int = 0


func _init(
		n_id: int, #
		#n_time: float = Time.get_unix_time_from_system(),
		n_name: String = "node", 
		
		n_size: Vector2 = Vector2(1.0, 1.0),
		n_rot: float = 0.0,
		
		n_type: String = "BASE",
		n_edges: Dictionary = {}, 
	):
		
	self.id = n_id
	self.time = Time.get_unix_time_from_system()
	self.name = n_name
	
	self.nodeSize = n_size
	self.nodeRotation = n_rot
	
	self.nodeType = n_type
	
	self.edges = n_edges
	
	
#func setRelatedNodePosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
#	assert(edges.has(int(nodeId)), "ERROR related node not found")
#	if relatedPos == Vector2.ZERO or relatedPos == null:
#		edges[nodeId].relativePosition = Vector2.ZERO
#	else:
#		edges[nodeId].relativePosition = relatedPos - selfPos
#
#func getRelatedNodePosition(nodeId: int, nodePosition: Vector2):
#	if !edges.keys().has(nodeId):
#		return
#
#	if edges[nodeId].relativePosition != Vector2.ZERO:
#		return nodePosition + edges[nodeId].relativePosition
#	else: 
#		assignedPositions += 1
#		return nodePosition + Vector2(0, 150 * assignedPositions)	
#
#func addRelatedNode(relatedId: int, relativePos: Vector2 = Vector2.ZERO):
#	edges[relatedId] = RelatedNodeData.new(relatedId, relativePos)
#
#
#func getRelatedNode(relatedId: int) -> RelatedNodeData: 
#	return edges[relatedId]
#
#func updateRelatedNode(u_id: int, u_position: Vector2):
#	assert(edges.has(u_id), "ERROR related node not found")
#	var relatedNode: RelatedNodeData = edges[u_id]
#	relatedNode.relativePosition = u_position
