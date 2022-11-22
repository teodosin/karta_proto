class_name RelatedNode

var id: int
var relativePosition: Vector2
var expanded: bool

func _init(rid: int, rrelativePosition: Vector2, rexpanded: bool = false):
	self.id = rid
	self.relativePosition = rrelativePosition
	self.expanded = rexpanded
