class_name ObjectRectangle
extends Node2D

@export var nodeId: int
@export var pos: Vector2
@export var size: Vector2
@export var color: Color

func _init(
	t_id: int = 0, 
	t_pos: Vector2 = Vector2.ZERO,
	t_size: Vector2 = Vector2.ZERO,
	t_col: Color = Color(1),
	):
		
	self.nodeId = t_id
	self.pos = t_pos
	self.size = t_size
	self.color = t_col
	
func _process(_delta):
	queue_redraw()
	
func _draw():
	draw_line(Vector2(-1000, 300), Vector2(2000, 400), Color(1), 5.0, true)
	draw_rect(Rect2(pos, size), color, true)
	print("Desperarely trying to draw at " + str(pos) + " " + str(size))
	print("Globally I am at " + str(self.global_position))

func setPosition(newPos: Vector2):
	self.pos = newPos
	
func setSize(newSz: Vector2):
	self.size = newSz
