@tool
extends CanvasLayer

signal open_docs

# Called when the node enters the scene tree for the first time.
func _ready():
	var text = FileAccess.get_file_as_string("res://addons/magnustalk/plugin.cfg")
	var fields = text.split("
")
	for field in fields:
		if field == "" or field == "[plugin]":
			fields.erase(field)
	for field in fields:
		if field.contains("="):
			fields[fields.find(field)] = field.split("=")[1].replace("\"","")
	var version = fields[3]
	$Control/Panel/title.text += " " + str(version)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_meta_clicked(meta):
	if meta == "docs":
		open_docs.emit()


func _on_close_pressed():
	queue_free()
