extends EditorInspectorPlugin

var ui_scale = 1.0

func can_handle(object):
	if object is SecondOrderSystem:
		return true
	return false

func parse_property(object, type, path, hint, hint_text, usage):
	if path == "preview_curve":
		var control = SecondOrderSystemPreview.new()
		control.ui_scale = ui_scale
		add_custom_control(control)
		return true
	return false
