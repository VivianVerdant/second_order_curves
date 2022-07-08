tool
class_name SecondOrderSystem
extends Resource

const PREVIEW_TIME = 0.25
const PREVIEW_RESOLUTION = 200.0

var xp # previous input
var y  # state variables
var yd

var frequency: float = 1 setget update_frequency
var damping: float = .5 setget update_damping
var response: float = 0 setget update_response

var k1: float = 0  # dynamics constants
var k2: float = 0
var k3: float = 0

var cached_preview = [0]

signal updated

func _init():
	compute(frequency, damping, response)
	if Engine.editor_hint:
		update_cache()

func _get_property_list():
	var properties = []
	properties.append({
		name = "Second Order System",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "Variables",
		type = TYPE_NIL,
		hint_string = "variables_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_DEFAULT
	})
	properties.append({
		name = "frequency",
		type = TYPE_REAL,
	})
	properties.append({
		name = "damping",
		type = TYPE_REAL,
	})
	properties.append({
		name = "response",
		type = TYPE_REAL,
	})
	properties.append({
		name = "Preview",
		type = TYPE_NIL,
		hint_string = "preview_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_DEFAULT
	})
	properties.append({
		name = "preview_curve",
		type = TYPE_ARRAY,
	})
	return properties

func update_frequency(value):
	frequency = value
	compute(frequency, damping, response)
	if Engine.editor_hint:
		update_cache()

func update_damping(value):
	damping = value
	compute(frequency, damping, response)
	if Engine.editor_hint:
		update_cache()
		
func update_response(value):
	response = value
	compute(frequency, damping, response)
	if Engine.editor_hint:
		update_cache()
	
func reset():
	compute(frequency, damping, response)

func compute(f: float , z: float, r: float, x0: float = 0):
	# compute constants
	k1 = z / (PI * f)
	k2 = 1 / ((2 * PI * f) * (2 * PI * f))
	k3 =r *z/ (2 * PI * f)
	
	# initialize variables
	xp = x0
	y = x0
	yd = 0
	
	#print(str(k1) + ":" + str(k2) + ":" + str(k3))

func update(T: float, x: float, xd = null):
	# estimate velocity
	if not xd:
		xd = (x - xp) / T
		xp = x
	
	# clamp k2 to guarantee stability without jitter
	var k2_stable = max(k2, max(T*T/2 + T*k1/2, T*k1))
	
	# integrate position by velocity
	y = y + T * yd
	
	# integrate velocity by acceleration
	yd = yd + T * (x + k3*xd - y - k1*yd) / k2_stable
	
	return y

func update_cache():
	cached_preview.clear()
	var temp = xp
	xp = 0
	compute(frequency, damping, response)
	var val
	var smallest = .5
	var largest = .5
	for t in range(PREVIEW_RESOLUTION):
		var time = t as float/PREVIEW_RESOLUTION*PREVIEW_TIME
		if (t==0): 
			cached_preview.append(0)
			continue 
		val = (0.0 if time == 0 else 1.0)
		cached_preview.append(update(time,val))
		if cached_preview[-1] > largest: largest = cached_preview[-1]
		if cached_preview[-1] < smallest: smallest = cached_preview[-1]
	cached_preview.append(smallest)
	cached_preview.append(largest)
	xp = temp
	emit_signal("updated")
	
