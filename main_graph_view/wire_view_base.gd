class_name WireViewBase
extends Node2D

var id: int 
var source: NodeViewBase
var target: NodeViewBase

var sourcePos: Vector2
var targetPos: Vector2

func _process(_delta):
	if !is_instance_valid(source) or !is_instance_valid(target):
		var despawnTween = create_tween()
		despawnTween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5)
		despawnTween.tween_callback(deleteSelf)

	
	if is_instance_valid(source):
		sourcePos = source.getPositionCenter()
	
	if is_instance_valid(target):
		targetPos = target.getPositionCenter()
	
	queue_redraw()
	
func deleteSelf():
	get_parent().remove_child(self)
	self.queue_free()	

func _draw():
	if is_instance_valid(target) and is_instance_valid(source):
		if source.isFocal or target.isFocal:
			draw_line(
				sourcePos, 
				targetPos, Color(0.0,0.1,0.1), 0.5, true
			)	
		else:
			draw_line(
				sourcePos, 
				targetPos, Color(0.0,0.1,0.1), 2.0, true
			)
