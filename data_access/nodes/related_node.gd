class_name RelatedNode
extends Resource

@export var id: int
@export var relativePosition: Vector2
@export var expanded: bool

func _init(rid: int = 0, rrelativePosition: Vector2 = Vector2.ZERO, rexpanded: bool = false):
	self.id = rid
	self.relativePosition = rrelativePosition
	self.expanded = rexpanded
