class_name WireBase

var sourceId: int
var targetId: int
var sourcePosition: Vector2
var targetPosition: Vector2

func _init(srcId: int, trgtId: int, distanceVector: Vector2):
	self.sourceId = srcId
	self.targetId = trgtId
	self.sourcePosition = distanceVector
	self.targetPosition = - distanceVector
