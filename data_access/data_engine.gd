class_name DataEngine


var dataAccess: DataAccess
#One node can be active at a time. The inputs to that node will be processed
var active: NodeBase

func _init(dataAcc: DataAccess):
	self.dataAccess = dataAcc
	
