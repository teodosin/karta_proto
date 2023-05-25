extends PopupMenu

var thisNode: NodeViewBase

func setNodeContext(node: NodeViewBase):
	thisNode = node

func _ready():
	add_check_item("Expanded: ", 0)

func _on_index_pressed(index):
	print("pressing index " + str(index))
	
	if thisNode.expanded:
		get_parent().collapseConnections(thisNode)
		set_item_checked(0, false)
	else:
		get_parent().expandConnections(thisNode)
		set_item_checked(0, true)

