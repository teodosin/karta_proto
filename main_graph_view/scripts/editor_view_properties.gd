extends VBoxContainer
class_name EditorViewProperties

var selected: NodeViewBase

var mainGraphView

func connectToSelector(view):
	print(view)
	mainGraphView = view
	
	mainGraphView.nodeSelected.connect(self.handleSelection)
	
func handleSelection(node: NodeViewBase):
	if node.dataNode.nodeType == "PROPERTIES":
		print("Not editing the properties of properties, dawg")
		return
	
	print("Calling loadProperties")
	loadProperties(node)

func loadProperties(node: NodeViewBase):
	for child in get_children():
		remove_child(child)
	
	for prprty in node.dataNode.typeData.get_property_list():
		if prprty["name"] == "RefCounted" or \
		prprty["name"] == "Resource" or \
		prprty["name"] == "resource_local_to_scene" or \
		prprty["name"] == "resource_path" or \
		prprty["name"] == "resource_name" or \
		prprty["name"] == "script" or \
		".gd" in prprty["name"]:
			continue
			
		var label = Label.new()
		label.text = str(prprty["name"])
		add_child(label)
	
	# Check if the NodeBase objectData field is filled
	if node.dataNode.objectData:
		# Check if the object has a method to get a list of our custom properties
		# since we don't want to display every property that exists
		if node.dataNode.objectData.has_method("getExportedProperties"):
			for prprty in node.dataNode.objectData.get_property_list():
				# If the property name is not in the exported properties, we ignore it
				if !prprty["name"] in node.dataNode.objectData.getExportedProperties():
					continue
					
				# Add label for the property name
				print(prprty)
				var label = Label.new()
				label.text = str(prprty["name"])
				add_child(label)
				
				# Add content label
				match prprty["hint_string"]:
					"Vector2":
						var horz = HBoxContainer.new()
						add_child(horz)
						
						var prop = node.dataNode.objectData.get(prprty["name"])
						
						print(str(prop))
						
						var labl = SpinBox.new()
						labl.allow_greater = true
						labl.allow_lesser = true
						labl.value = prop.x
						labl.value_changed.connect(self.handle_property_edit.bind(prop.x))
						horz.add_child(labl)
						
						var labul = SpinBox.new()
						labul.allow_greater = true
						labul.allow_lesser = true
						labul.value = prop.y
						labul.value_changed.connect(self.handle_property_edit.bind(prop.y))
						horz.add_child(labul)
					_:
						pass
						
func handle_property_edit(value: float, prop):
	print("handling")
	prop = value
	
