class_name WireBaseData
extends Resource

var edgeId: int

var sourceId: int
var sourceRelativeData: RelatedNodeData

var targetId: int
var targetRelativeData: RelatedNodeData

var edgeType: String
var edgeGroup: String

func _init(
		wireId: int, 
		srcId: int, 
		trgtId: int, 
		type: String, 
		group: String
		):
	self.id = wireId
	
	self.sourceId = srcId
	self.sourceRelativeData = RelatedNodeData.new(srcId)
	
	self.targetId = trgtId
	self.targetRelativeData = RelatedNodeData.new(trgtId)
	
	self.wireType = type
	self.wireGroup = group
