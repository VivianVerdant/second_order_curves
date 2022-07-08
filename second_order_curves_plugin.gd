tool
extends EditorPlugin

var plugin
var icon

func _enter_tree():
	plugin = preload("res://addons/second_order_curves/editor_plugin.gd").new()
	plugin.ui_scale  = get_editor_interface().get_editor_settings().get_setting("interface/editor/display_scale")
	icon = get_editor_interface().get_base_control().theme.get_icon("Curve", "EditorIcons")
	add_custom_type("SecondOrderCurve", "Node", preload("res://addons/second_order_curves/second_order_curve.gd"), icon)
	get_editor_interface().get_base_control().theme.set_icon("SecondOrderCurve", "EditorIcons", icon)
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)
	remove_custom_type("SecondOrderCurve")
