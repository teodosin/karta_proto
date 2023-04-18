extends Resource
class_name WireBaseData

@export var edgeId: int

@export var sourceId: int
@export var sourceRelativeData: RelatedNodeData

@export var targetId: int
@export var targetRelativeData: RelatedNodeData

@export var edgeType: String
@export var edgeGroup: String

func _init(
		wireId: int, 
		srcId: int, 
		trgtId: int, 
		type: String = "", 
		group: String = ""
		):
	self.id = wireId
	
	self.sourceId = srcId
	self.sourceRelativeData = RelatedNodeData.new(srcId)
	
	self.targetId = trgtId
	self.targetRelativeData = RelatedNodeData.new(trgtId)
	
	self.wireType = type
	self.wireGroup = group
	
func setType(type: String):
	self.wireType = type
func setGroup(group: String):
	self.wireGroup = group

func getConnection(nodeId: int): 
	if nodeId == sourceId:
		return targetRelativeData
	elif nodeId == targetId:
		return sourceRelativeData
