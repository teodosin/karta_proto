extends VBoxContainer

var enums = preload("res://data_access/enum_node_types.gd").EdgeTypes
@onready var typeBtn = $EdgeType
@onready var popup = $EdgeTypeSelector

var edgeType = "BASE"
var edgeGroup = ""

func _ready():
	typeBtn.text = enums.keys()[enums.BASE]
	
	for type in enums:
		popup.add_item(type, enums[type])


func _on_edge_type_pressed():
	popup.popup()
	popup.position = get_viewport().get_mouse_position()
