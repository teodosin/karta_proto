extends NodeTypeData
class_name NodeGobject

var nodeId
var children: Array 

func _init(
	nid: int = 0,
):
	self.nodeId = nid

"""
> A node is set as focal and is of nodeType "Gobject"
> The dataNode of that node is of class_name NodeGobject 
> The dataNode requests the loading of all Gobject children 

"""
