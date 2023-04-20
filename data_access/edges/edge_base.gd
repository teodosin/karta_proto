class_name EdgeBase
extends Resource

@export var id: int

@export var sourceId: int
@export var sourceRelativeData: RelatedNode

@export var targetId: int
@export var targetRelativeData: RelatedNode

@export var edgeType: String
@export var edgeGroup: String

func _init(
		eId: int = 0, 
		srcId: int = 0, 
		trgtId: int = 0, 
		type: String = "", 
		group: String = ""
		):
	self.id = eId
	
	self.sourceId = srcId
	self.sourceRelativeData = RelatedNode.new(srcId)
	
	self.targetId = trgtId
	self.targetRelativeData = RelatedNode.new(trgtId)
	
	self.edgeType = type
	self.edgeGroup = group
	
func setType(type: String):
	self.edgeType = type
func setGroup(group: String):
	self.edgeGroup = group

func getConnection(nodeId: int): 
	if nodeId == sourceId:
		return targetRelativeData
	elif nodeId == targetId:
		return sourceRelativeData
