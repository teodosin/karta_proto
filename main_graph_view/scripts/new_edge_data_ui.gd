extends VBoxContainer

var enums = preload("res://data_access/enum_node_types.gd").EdgeTypes
@onready var typeBtn = $EdgeType
@onready var popup = $EdgeTypeSelector

var edgeType: String = "BASE"
var edgeGroup: String = ""

func _ready():
	edgeType = enums.keys()[enums.BASE]
	typeBtn.text = edgeType
	
	for type in enums:
		popup.add_item(type, enums[type])


func _on_edge_type_pressed():
	popup.popup()
	popup.position = get_viewport().get_mouse_position()


func _on_edge_type_selector_index_pressed(index):
	edgeType = enums.keys()[index]
	typeBtn.text = edgeType

func _on_edge_group_edit_focus_entered():
	owner.handle_disable_shortcuts(true)

func _on_edge_group_edit_focus_exited():
	owner.handle_disable_shortcuts(false)

func _on_edge_group_edit_text_changed(new_text):
	edgeGroup = new_text
