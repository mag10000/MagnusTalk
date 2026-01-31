@tool
extends CanvasLayer

signal run_scene
signal edit
signal clone
signal refresh
signal render
signal docs(html : String)

var laungage = ""
var gotten_docs = false
var doc_html = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$HTTPRequest.request("https://magnusknisely.wixsite.com/magnus-talk-plugin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$Panel.visible = !$Panel.visible


func _on_test_pressed():
	$TestFileDialog.show()


func _on_test_file_dialog_file_selected(path):
	var file = FileAccess.open("user://debugdata.txt", FileAccess.WRITE)
	file.store_string(path)
	file.close()
	file = null
	MagnusTalkTech._start_debug_dialouge = path
	run_scene.emit()


func _on_edit_pressed():
	edit.emit()


func _on_clone_pressed():
	clone.emit()

var globalscene = ""
var globalgd = ""
func _on_timer_timeout():
	var scene = FileAccess.get_file_as_string("res://addons/magnustalk/taskbar.tscn")
	var gd = FileAccess.get_file_as_string("res://addons/magnustalk/taskbar.gd")
	if globalscene != scene or globalgd != gd:
		refresh.emit()
	globalscene = scene
	globalgd = gd


func _on_render_pressed():
	render.emit()


func _on_http_request_request_completed(result, response_code, headers, body):
	$HTTPRequest.request("https://magnusknisely.wixsite.com/magnus-talk-plugin")
	doc_html = body.get_string_from_utf8().split("text-align:center; font-size:22px;\">")
	if doc_html.size() > 1:
		doc_html = doc_html[1].split("</p")[0].replace("&lt;","<").replace("&gt;",">").replace("<span class=\"wixui-rich-text__text\">","").replace("</span>","").replace("</doc_title>","<doc_title>")
	gotten_docs = true
	$Panel/HBoxContainer/docs.disabled = false


func _on_docs_pressed():
	docs.emit(doc_html)


func _on_csv_pressed():
	$CsvFileDialog.show()

var csv_save_to_path = ""
func _on_csv_file_dialog_file_selected(path):
	csv_save_to_path = path
	$CsvFileDialog2.popup()


func _on_csv_file_dialog_2_file_selected(path):
	var lines = FileAccess.get_file_as_string(path).split("
")
	var csv_text = "key," + laungage
	for line in lines:
		if line.contains(","):
			csv_text += "
LINE_" +  str(lines.find(line) + 1) + ",\"" + line + "\""
		else:
			csv_text += "
LINE_" +  str(lines.find(line) + 1) + "," + line + ""
	var file = FileAccess.open(csv_save_to_path, FileAccess.WRITE)
	file.store_string(csv_text)
	file.close()
	file = null
