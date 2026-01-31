extends Node

signal Mfunc(function : String)
var _global_vars = {}

func start_dialouge(path : String):
	var box_scene = preload("res://addons/magnustalk/box.tscn")
	var box = box_scene.instantiate()
	add_child(box)
	if FileAccess.file_exists(path):
		box.open_dialouge(path)
	else:
		printerr("The Specified Dialouge Path Does Not Exist")
	box.function_call.connect(function_call)

func start_dialouge_from_custom_box(path : String,box : String):
	if FileAccess.file_exists(box):
		var _box = load(box)
		var inbox = _box.instantiate()
		add_child(inbox)
		if FileAccess.file_exists(path):
			inbox.open_dialouge(path)
		else:
			printerr("The Specified Dialouge Path Does Not Exist")
		inbox.function_call.connect(function_call)
	else:
		printerr("The Specified Box Path Does Not Exist. Using Default Box.")
		start_dialouge(path)

func define_global_var(name : String,value = null):
	_global_vars[name] = value

func get_global_var(name : String):
	if _global_vars.has(name):
		return _global_vars[name]

func function_call(_name):
	Mfunc.emit(_name)
