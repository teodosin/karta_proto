extends Resource
class_name InputSocket

@export var maxConnections: int

@export var connections: Array

signal mouseHovering

func _init(
	maxCon: int = 1,
	cons: Array = []
):
	maxConnections = maxCon
	connections = cons

func addConnection(edgeId: int):
	if connections.size() >= maxConnections:
		return
	else:
		connections.append(edgeId)
