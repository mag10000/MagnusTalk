@tool
extends CanvasLayer

var text = ""
var chaps = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect/RichTextLabel.text = text
	var split = text.split("<doc_title>")
	var numb = 1
	var pre = ""
	for text in split:
		if numb % 2 != 0:
			print(numb % 2)
			text = text.replace(text,"")
			chaps[text] = pre
		else:
			print(numb % 2)
			pre = text
		numb += 1
	print(text)
	print(chaps)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	queue_free()

func get_tag(text,tag):
	var regex = RegEx.new()
	regex.compile("<" + tag + ">(.|\\n)*?</" + tag + ">")
	var result = regex.search(text)
	if result:
		return result.get_string().replace("<doc_title>","").replace("</doc_title>","")
