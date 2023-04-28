class_name NodeText
extends NodeTypeData

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

func updateSize(newSize: Vector2):
	nodeSize = newSize
	
func updateText(newText: String):
	nodeText = newText
