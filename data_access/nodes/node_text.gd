class_name NodeText

var nodeId: int
var nodeSize: Vector2
var nodeText: String

func _init(tid, tsize, ttext):
	self.nodeId = tid
	self.nodeSize = tsize
	self.nodeText = ttext
