extends ItemList

var tools = preload("res://main_graph_view/interaction_modes.gd")

signal toolChanged(tool)

func _ready():
	for tool in tools.interactionModes:
		add_item(tool)
	
	if owner.activeTool:
		select(owner.activeTool)
	
	
	# Tooltips! They're ugly as hell but useful. Would love a custom one for Karta. 
	for tool in tools.interactionModes:
		set_item_tooltip_enabled(int(tool), true)
		
	set_item_tooltip(tools.interactionModes.MOVE, 
		"Shortcut - (G) \n
		Clicking and dragging nodes will move them."
	)

	set_item_tooltip(tools.interactionModes.FOCAL, 
		"Shortcut - (F) \n
		Clicking on a node will move you into its Context. Relevant nodes will be loaded and spawned in."
	)
		
	set_item_tooltip(tools.interactionModes.TRANSITION,
		"Shortcut - (T) \n
		Transition between valid states."
	)

	set_item_tooltip(tools.interactionModes.EDGES,
		"Shortcut - (E) \n
		Connect nodes to each other. Edge will have the group and type specified below."
	)
	
	set_item_tooltip(tools.interactionModes.DRAW,
		"Shortcut - (D) \n
		Draw rectangles on the background scene."
	)

func _on_item_clicked(index, _at_position, _mouse_button_index):
	toolChanged.emit(index)
