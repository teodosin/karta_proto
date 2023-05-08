extends ItemList

var tools = preload("res://main_graph_view/interaction_modes.gd")

signal toolChanged(tool)

func _ready():
	for tool in tools.interactionModes:
		add_item(tool)
	

func _on_item_clicked(index, at_position, mouse_button_index):
	toolChanged.emit(index)
