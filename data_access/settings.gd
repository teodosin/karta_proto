extends Resource

class_name KartaSettings

@export var lastId: int
@export var lastFocalId: int

func _init(
		s_lastId: int = 0, 
		s_lastFocalId: int = 0
		):
			
	self.lastId = s_lastId
	self.lastFocalId = s_lastFocalId

