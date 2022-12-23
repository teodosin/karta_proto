class_name SpawnNodeCommand extends Command

var nodeType: String
var atMouse: bool

func _init(
	nType: String,
	atMous: bool
):
	self.nodeType = nType
	self.atMouse = atMous
	
func execute():
	pass
	
func undo():
	pass
