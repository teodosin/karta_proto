class_name EdgeBase
extends Resource

var id: int
var sourceId: int
var targetId: int
var edgeType: String
var edgeGroup: String

	

func _init(edgeId: int, srcId: int, trgtId: int, type: String, group: String):
	self.id = edgeId
	self.sourceId = srcId
	self.targetId = trgtId
	self.edgeType = type
	self.edgeGroup = group
