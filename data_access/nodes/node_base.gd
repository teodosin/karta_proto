class_name NodeBase
extends Resource

const Enums = preload("res://data_access/enum_node_types.gd")

@export var id: int
@export var time: float
@export var name: String

@export var nodeType: String
@export var typeData: NodeTypeData

@export var edges: Dictionary # connectedNodeId -> edgeId



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
	
	self.nodeType = n_type
	self.typeData = NodeTypeData.new()
	
	self.edges = n_rel	
		
func addEdge(connectionId: int, edgeId):
	edges[connectionId] = edgeId

func getEdgeId(connectionId: int) -> int: 
	return edges[connectionId]
	
