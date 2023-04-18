extends Resource
class_name Settings

@export var lastId: int

func _init():
	self.lastId = 0

func incrementLastId():
	lastId += 1
	DataAccessor.save_settings()
	
func getLastId():
	return lastId
