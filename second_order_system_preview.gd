class_name SecondOrderSystemPreview
extends EditorProperty

# The main control for editing the property.
var curve = DrawCurve.new()
# An internal value of the property.
var cache = [0]
var time_length
# A guard against internal changes when the property is updated.
var updating = false
var ui_scale = 1.0

class DrawCurve:
	extends ReferenceRect
	var cache = [0]
	var time_length
	var ui_scale = 1.0
	
	func _init():
		editor_only = true
		border_color = Color(0,0,0,0)
		size_flags_horizontal = 3
		rect_min_size = Vector2(100,200)
		
	func _draw():
		var view_size = get_rect().size
		var font = get_font("font", "Label")
		var font_height = font.get_height()
		var char_width = font.get_char_size(49).x*3
		var border_color = get_color("font_color", "Editor")
		var grid_color = border_color.darkened(0.5)
		
		# Background

		draw_rect(Rect2(Vector2.ZERO, view_size),border_color,false,true)
		
		# Transform space
		var margin = 0.1
		var height = (cache[-1] - cache[-2])
		var scale = view_size.y / height * (1.0 - margin)
		var resolution = time_length/(cache.size() - 3.0)
		draw_set_transform_matrix(Transform2D(Vector2(view_size.x/time_length, 0), Vector2(0, -scale), Vector2(0, view_size.y * (1.0 - margin * 0.5) + cache[-2] * scale )))
		
		# Grid
		
		# X axis
		var off = 0.0
		draw_line(Vector2(0.0, off), Vector2(time_length, off), grid_color, 1.0, true)
		off = 1.0
		draw_line(Vector2(0.0, off), Vector2(time_length, off), grid_color, 1.0, true)
		
		# Y axis
		off = 1.0/16.0
		draw_line(Vector2(off, cache[-1] + margin * 0.5), Vector2(off, cache[-2] - margin * 0.5), grid_color, 1.0, true)
		off = 2.0/16.0
		draw_line(Vector2(off, cache[-1] + margin * 0.5), Vector2(off, cache[-2] - margin * 0.5), grid_color, 1.0, true)
		off = 3.0/16.0
		draw_line(Vector2(off, cache[-1] + margin * 0.5), Vector2(off, cache[-2] - margin * 0.5), grid_color, 1.0, true)
		
		# Line
		for x in cache.size()-3:
			if cache[x]:
				var x1 = (x as float - 1) * resolution
				var y1 = cache[x]
				var x2 = (x as float) * resolution
				var y2 = cache[x+1]
				draw_line(Vector2(x1, y1), Vector2(x2, y2), border_color, 1.0, true)
		

func _init():
	label = "Preview"
	# Add the control as a direct child of EditorProperty node.
	curve.ui_scale = ui_scale
	curve.ui_scale
	add_child(curve)
	set_bottom_editor(curve)

func _ready():
	get_parent().add_child(MarginContainer.new())
	# Setup the initial state.
	curve.cache = get_edited_object().cached_preview
	curve.ui_scale = ui_scale
	get_edited_object().connect("updated", self, "on_updated")

func on_updated():
	var new_cache = get_edited_object().cached_preview
	var new_time_length = get_edited_object().PREVIEW_TIME
	updating = true
	cache = new_cache
	curve.cache = new_cache
	time_length = new_time_length
	curve.time_length = new_time_length
	curve.update()
	updating = false

func update_property():
	var new_cache = get_edited_object().cached_preview
	var new_time_length = get_edited_object().PREVIEW_TIME
	updating = true
	cache = new_cache
	curve.cache = new_cache
	time_length = new_time_length
	curve.time_length = new_time_length
	curve.update()
	updating = false

	

