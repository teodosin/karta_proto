extends ItemList

var tools = preload("res://main_graph_view/interaction_modes.gd")

signal toolChanged(tool)

func _ready():
	for tool in tools.interactionModes:
		add_item(tool)
	
	if owner.activeTool:
		select(owner.activeTool)
	
	for tool in tools.interactionModes:
		set_item_tooltip_enabled(int(tool), true)
		
	set_item_tooltip(tools.interactionModes.MOVE, 
		"Clicking and dragging nodes will move them.")

	set_item_tooltip(tools.interactionModes.FOCAL, 
		"Clicking on a node will set it as the Focal node. \n
		Relevant nodes will be loaded and spawned in.")

func _on_item_clicked(index, at_position, mouse_button_index):
	toolChanged.emit(index)
