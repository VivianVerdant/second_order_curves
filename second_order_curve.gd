tool
#class_name SecondOrderCurve
extends Node

signal value_changed(value)

var system = SecondOrderSystem.new()

var value: float setget update_value

func update_value(new_value):
	if new_value:
		var t = 1.0 / Engine.get_frames_per_second()
		value = system.update(t, new_value)
	emit_signal("value_changed", value)

func _get_property_list():
	var properties = []
	properties.append({
		name = "Second Order Curve",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "value",
		type = TYPE_REAL,
	})
	properties.append({
		name = "system",
		hint_text = "Second Order System",
		type = TYPE_OBJECT,
	})
	return properties
