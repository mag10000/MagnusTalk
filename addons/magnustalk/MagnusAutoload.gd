extends Node

var _global_vars = {}

func start_dialouge(path : String):
	var box_scene = preload("res://addons/magnustalk/box.tscn")
	var box = box_scene.instantiate()
	add_child(box)
	box.open_dialouge(path)

func start_dialouge_from_custom_box(path : String,box : String):
	if FileAccess.file_exists(box):
		var _box = load(box)
		var inbox = _box.instantiate()
		add_child(inbox)
		inbox.open_dialouge(path)
	else:
		start_dialouge(path)

func define_global_var(name : String,value = null):
	_global_vars[name] = value

func get_global_var(name : String):
	if _global_vars.has(name):
		return _global_vars[name]
