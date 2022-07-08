tool
extends Spatial

onready var curve = $SecondOrderCurve
onready var sphere = $CSGSphere

func _ready():
	curve.value = translation.x
	sphere.set_as_toplevel(true)

func _process(delta):
	curve.value = translation.x

func _on_SecondOrderCurve_value_changed(value):
	sphere.global_transform.origin.x = value
