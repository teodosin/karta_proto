class_name CreateNodeCommand extends Command

var nodeType: String
var atMouse: bool

var dataAccess: DataAccessInMemory
var spawner: Spawner

func _init(
	nType: String,
	atMous: bool,
	
	dataAcc: DataAccessInMemory,
	spwner: Spawner
):
	self.nodeType = nType
	self.atMouse = atMous
	
	self.dataAccess = dataAcc
	self.spawner = spwner
	
func execute():
	pass
	
func undo():
	pass

# ------------------------------------------

