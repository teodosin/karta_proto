class_name WireBase

var id: int
var sourceId: int
var targetId: int
var wireType: String
var wireGroup: String

	

func _init(wireId: int, srcId: int, trgtId: int, type: String, group: String):
	self.id = wireId
	self.sourceId = srcId
	self.targetId = trgtId
	self.wireType = type
	self.wireGroup = group
