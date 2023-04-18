extends NodeViewBase

func _ready():
	if nodeData.typeData:
		assert(nodeData.typeData is NodeTextData)
		
		$VBoxContainer/TextEdit.text = nodeData.typeData.nodeText
		custom_minimum_size = nodeData.typeData.nodeSize
		
	baseReady()

func _process(_delta):
	baseProcess()

func _on_text_edit_text_changed():
	nodeData.typeData.nodeText = $VBoxContainer/TextEdit.text


func _on_gui_input(event):
	on_self_input(event)
