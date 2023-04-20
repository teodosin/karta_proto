class_name EdgeBase
extends Resource

@export var id: int
@export var sourceId: int
@export var targetId: int
@export var edgeType: String
@export var edgeGroup: String

	

func _init(edgeId: int, srcId: int, trgtId: int, type: String, group: String):
	self.id = edgeId
	self.sourceId = srcId
	self.targetId = trgtId
	self.edgeType = type
	self.edgeGroup = group	

