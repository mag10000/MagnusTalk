@tool
extends CanvasLayer

var text = ""
var titles = ["intro"]
var texts = []
var chap_to_text = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	text = text.replace("[enter]","
")
	$ColorRect/RichTextLabel.text = text
	var split = text.split("<doc_title>")
	var numb = 1
	var pre = ""
	for text in split:
		if numb % 2 == 0:
			titles.insert(titles.size(),text)
		else:
			texts.insert(texts.size(),text)
		numb += 1
	print("texts: ",texts)
	print("titles: ",titles)
	for title in titles:
		chap_to_text[title] = texts[titles.find(title)]
	print(chap_to_text)


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
