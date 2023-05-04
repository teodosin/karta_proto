extends Node
class_name InputSocket

@export var maxConnections: int

@export var connections: Dictionary

func _init(
	maxCon: int = 1,
	cons: Dictionary = {}
):
	maxConnections = maxCon
	connections = cons
