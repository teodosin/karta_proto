class_name NodeImage
extends Resource

@export var nodeId: int
@export var nodeSize: Vector2
@export var imagePath: String

func _init(
	tid: int = 0, 
	tsize: Vector2 = Vector2.ZERO, 
	tpath: String = ""
	):
		
	self.nodeId = tid
	self.nodeSize = tsize
	self.imagePath = tpath