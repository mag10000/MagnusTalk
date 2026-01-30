@tool
extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_file_dialog_canceled():
	queue_free()


func _on_file_dialog_file_selected(path):
	$CodeEdit.text = FileAccess.get_file_as_string(path)
	$CodeEdit.text = $CodeEdit.text.replace("Mchar[","")
	$CodeEdit.text = $CodeEdit.text.replace("Mopo[] ","- ")
	$CodeEdit.text = $CodeEdit.text.replace("Mjump[","(Line warps to ")
	$CodeEdit.text = $CodeEdit.text.replace("] ",": ")
	$CodeEdit.text = $CodeEdit.text.replace("]",")")


func _on_close_pressed():
	queue_free()


func _on_open_pressed():
	$FileDialog.popup()
