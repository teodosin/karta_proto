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

func addSource(srcId: int, relPos: Vector2 = Vector2.ZERO):
	sourceId = srcId
	sourceRelativeData = RelatedNode.new(srcId)
func addTarget(trgtId: int, relPos: Vector2 = Vector2.ZERO):
	self.targetId = trgtId
	self.targetRelativeData = RelatedNode.new(trgtId)
	
func setSourcePosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
	if relatedPos == Vector2.ZERO or relatedPos == null:
		sourceRelativeData.relativePosition = Vector2.ZERO
	else:
		sourceRelativeData.relativePosition = relatedPos - selfPos
		
	print("sourceRelative in edge is " + str(sourceRelativeData.relativePosition))

func setTargetPosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
	if relatedPos == Vector2.ZERO or relatedPos == null:
		targetRelativeData.relativePosition
	else:
		targetRelativeData.relativePosition = relatedPos - selfPos
	
	print("targetRelative is in edge" + str(targetRelativeData.relativePosition))

func getConnection(nodeId: int): 
	if nodeId == sourceId:
		return targetRelativeData
	elif nodeId == targetId:
		return sourceRelativeData
