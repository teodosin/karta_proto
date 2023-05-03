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
		sourceRelativeData.setRelativePosition(Vector2.ZERO)
	else:
		sourceRelativeData.setRelativePosition(relatedPos - selfPos)
		
	print("sourceRelative in edge is " + str(sourceRelativeData.relativePosition))

func setTargetPosition(nodeId: int, selfPos: Vector2, relatedPos: Vector2):
	if relatedPos == Vector2.ZERO or relatedPos == null:
		targetRelativeData.setRelativePosition(Vector2.ZERO)
	else:
		targetRelativeData.setRelativePosition(relatedPos - selfPos)
	
	print("targetRelative in edge is" + str(targetRelativeData.relativePosition))

func getConnection(nodeId: int): 
	if nodeId == sourceId:
		return targetRelativeData
	elif nodeId == targetId:
		return sourceRelativeData
		
func setConnectionPosition(nodeId: int, selfPos: Vector2, relPos: Vector2):
	var editData = getConnection(nodeId)
	editData.setRelativePosition(relPos - selfPos)

func getConnectionPosition(nodeId: int):
	var getData = getConnection(nodeId)
	return getData.relativePosition
