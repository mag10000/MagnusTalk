@tool
extends CanvasLayer

signal open_tscn(tscn_path : String)
var text = ""
var titles = ["Intro"]
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
	for title in titles:
		chap_to_text[title] = texts[titles.find(title)]
	
	for chap in chap_to_text:
		var scene = preload("res://addons/magnustalk/doc_button.tscn")
		var instance = scene.instantiate()
		instance.text = chap
		instance.stored_body = chap_to_text[chap]
		$ColorRect/Panel/VBoxContainer.add_child(instance)
	$ColorRect/RichTextLabel.text = chap_to_text["Intro"]
	$ColorRect/title.text = "[b]" + "Intro"


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


func _on_rich_text_label_meta_clicked(meta):
	if str(meta).contains("res://"):
		open_tscn.emit(str(meta))
	else:
		OS.shell_open(str(meta))
