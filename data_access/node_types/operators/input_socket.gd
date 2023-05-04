extends Resource
class_name InputSocket

@export var maxConnections: int

@export var connections: Array

func _init(
	maxCon: int = 1,
	cons: Array = []
):
	maxConnections = maxCon
	connections = cons

func addConnection(nodeId: int):
	if connections.size() >= maxConnections:
		return
	else:
		connections.append(nodeId)
