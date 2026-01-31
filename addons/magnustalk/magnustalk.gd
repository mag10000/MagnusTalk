@tool
extends EditorPlugin

var taskbar
var poupop 
var render

func _enable_plugin():
	add_autoload_singleton("MagnusTalk","res://addons/magnustalk/MagnusAutoload.gd")
	add_autoload_singleton("MagnusTalkTech","res://addons/magnustalk/MagnusAutoloadTech.gd")


func _disable_plugin():
	remove_autoload_singleton("MagnusTalk")
	remove_autoload_singleton("MagnusTalkTech")


func _enter_tree():
	EditorInterface.edit_script(load("res://addons/magnustalk/doctest.gd"))
	add_tool_menu_item("Edit Dialouge Box",_edit_box)
	add_tool_menu_item("Clone Dialouge Box",_clone_box)
	add_tool_menu_item("Test Dialouge",_test)
	add_tool_menu_item("Render Dialouge",_render_text)
	add_tool_menu_item("Magnus Talk Docs",docs)
	var taskbar_scene = preload("res://addons/magnustalk/taskbar.tscn")
	var taskbar_instance = taskbar_scene.instantiate()
	taskbar = taskbar_instance
	add_child(taskbar_instance)
	taskbar.run_scene.connect(run_scene)
	taskbar.edit.connect(_edit_box)
	taskbar.clone.connect(_clone_box)
	taskbar.render.connect(_render_text)
	taskbar.docs.connect(_docs)


func _exit_tree():
	# Clean-up of the plugin goes here.
	taskbar.queue_free()
	remove_tool_menu_item("Edit Dialouge Box")
	remove_tool_menu_item("Clone Dialouge Box")
	remove_tool_menu_item("Test Dialouge")
	remove_tool_menu_item("Render Dialouge")
	remove_tool_menu_item("Magnus Talk Docs")
	if poupop:
		poupop.queue_free()
	if render:
		poupop.queue_free()

func _edit_box():
	EditorInterface.open_scene_from_path("res://addons/magnustalk/box.tscn")


func _clone_box():
	var scene = preload("res://addons/magnustalk/FileDialougeClone.tscn")
	var instance = scene.instantiate()
	poupop = instance
	instance.file_selected.connect(_clone_from)
	add_child(instance)

func run_scene():
	EditorInterface.play_custom_scene("res://addons/magnustalk/boxDebug.tscn")

func _clone_from(path):
	if not EditorInterface.is_playing_scene():
		if not FileAccess.file_exists(path):
			EditorInterface.open_scene_from_path("res://addons/magnustalk/box.tscn")
			EditorInterface.save_scene_as(path)

func _test():
	taskbar._on_test_pressed()

func _render_text():
	var scene = preload("res://addons/magnustalk/render_scene.tscn")
	var instance = scene.instantiate()
	render = instance
	add_child(instance)

var doc
func _docs(text):
	var scene = preload("res://addons/magnustalk/docs.tscn")
	var instance = scene.instantiate()
	instance.text = text
	doc = instance
	add_child(instance)

func docs():
	if taskbar.gotten_docs:
		_docs(taskbar.doc_html)
