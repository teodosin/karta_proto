extends VBoxContainer

var IndicatorToggle = preload("res://main_graph_view/components/indicator_toggle.tscn")
# Called when the node enters the scene tree for the first time.
var focalIndicator
var positionIndicator
var uiIndicator
var presenceIndicator

func _ready():
	focalIndicator = IndicatorToggle.instantiate()
	focalIndicator.onlyOn = true
	add_child(focalIndicator)
	
#	positionIndicator = IndicatorToggle.instantiate()
#	add_child(positionIndicator)
#
#	uiIndicator = IndicatorToggle.instantiate()
#	add_child(uiIndicator)
#
#	presenceIndicator = IndicatorToggle.instantiate()
#	add_child(presenceIndicator)

