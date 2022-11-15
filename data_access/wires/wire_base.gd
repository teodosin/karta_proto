class_name WireBase

var id: int
var sourceId: int
var targetId: int

	

func _init(wireId: int, srcId: int, trgtId: int):
	self.id = wireId
	self.sourceId = srcId
	self.targetId = trgtId
