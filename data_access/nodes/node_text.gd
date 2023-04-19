class_name NodeText
extends Resource

@export var nodeId: int
@export var nodeSize: Vector2
@export var nodeText: String

func _init(
	tid: int, 
	tsize: Vector2, 
	ttext: String
	):
		
	self.nodeId = tid
	self.nodeSize = tsize
	self.nodeText = ttext
