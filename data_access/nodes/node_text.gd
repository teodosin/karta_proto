class_name NodeText
extends Resource

@export var nodeId: int
@export var nodeSize: Vector2
@export var nodeText: String

func _init(
	nid: int = 0, 
	tsize: Vector2 = Vector2.ZERO, 
	ttext: String = ""
	):
		
	self.nodeId = nid
	self.nodeSize = tsize
	self.nodeText = ttext
