extends PopupMenu

const Enums = preload("res://data_access/enum_node_types.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	for num in Enums.NodeTypes:
		add_item(num.capitalize(), Enums.NodeTypes[num])



