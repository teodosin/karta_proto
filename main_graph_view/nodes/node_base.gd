class_name NodeBase
extends Node2D

var id: int


# Called when the node enters the scene tree for the first time.
func _ready():
	$IdLabel.text = str(id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
