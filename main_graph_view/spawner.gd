class_name Spawner

var spawnedNodes: Dictionary
var spawnedWires: Dictionary

func nodeSpawn(node: NodeViewBase):
	spawnedNodes[node.id] = node

func wireSpawn(wire: WireViewBase):
	spawnedWires[wire.id] = wire
