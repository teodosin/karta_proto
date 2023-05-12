class_name ObjectRectangle
extends NodeTypeData

@export var nodeId: int
@export var position: Vector2
@export var size: Vector2
@export var color: Color


func _init(
	t_id: int = 0, 
	t_pos: Vector2 = Vector2.ZERO,
	t_size: Vector2 = Vector2.ZERO,
	t_col: Color = Color(1),
	):
		
	self.nodeId = t_id
	self.position = t_pos
	self.size = t_size
	self.color = t_col
	
