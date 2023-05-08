extends VBoxContainer

var tools = preload("res://main_graph_view/interaction_modes.gd")

signal toolChanged(tool)

func _ready():
	for tool in tools.interactionModes:
		var toolButton = Button.new()
		toolButton.text = tool
		
		add_child(toolButton)

