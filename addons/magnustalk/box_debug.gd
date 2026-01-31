extends CanvasLayer  
var check_line
var lines
var current_line = 0
var last_line
var local_variables = {}
var global_variables = {}
var box_click = false
var start_open
var groups = {}
@export_group("Typing")
@export var use_typing = true
@export var speed : float = 3
@export var pause_speed : float = 4
@export var pauses : PackedStringArray = [".","!","?"]
@export_group("Nodes")
@export var audio_output : AudioStreamPlayer
@export var character_portrait : TextureRect
@export var text_output : RichTextLabel
@export var character_label : RichTextLabel
@export var options : VBoxContainer
@export var button : Button
@export var box : Panel
@export var triangle : Polygon2D
@export_group("Other Options")
@export var use_portraits : bool = true
@export var use_audio : bool = true
@export var audio_volume : float = 0.0

func _ready():
	box.hide()
	options.hide()
	var path = "user://debugdata.txt"
	var text = FileAccess.get_file_as_string(path)
	open_dialouge(text)
	DirAccess.remove_absolute(path)

func open_dialouge(path):
	triangle.show()
	box.show()
	local_variables = {}
	var text = FileAccess.get_file_as_string(path)
	lines = text.split("
")
	print(lines)
	if lines.size() > 0:
		last_line = lines.size() - 1
	else:
		last_line = 0
	for line in lines:
		if line.contains("*** "):
			groups[line.split(" ***")[0].replace("*** ","")] = lines.find(line)
			lines[lines.find(line)] = ""
	start_dialouge()

func start_dialouge():
	global_variables = MagnusTalk._global_vars
	box_click = true
	button.show()
	if not current_line > last_line:
		var line_text = lines[current_line]
		if line_text == "":
			current_line += 1
			start_dialouge()
		else:
			if line_text == "Mjump[END]":
				stop_dialouge()
				return
			if line_text.contains("Mopo[] "):
				button.hide()
				options.show()
				var jumpto
				var jumptoformat1 = line_text.split("Mjump")[1]
				jumpto = (jumptoformat1)
				var button_scene = preload("res://addons/magnustalk/option.tscn")
				var button = button_scene.instantiate()
				button.text = line_text.replace("Mopo[] ","").split(" Mjump")[0]
				button.jump_to = jumpto
				options.add_child(button)
				print(lines[current_line + 1])
				if not lines.size() - 1 == current_line:
					if lines[current_line + 1].contains("Mopo[] "):
						current_line += 1
						start_dialouge()
				return
			if line_text.contains("Mjump["):
				var line = int(line_text)
				var lines_text = line_text.replace("Mjump[","").replace("]","")
				print(lines_text)
				if str(line) != lines_text:
					print(lines_text,2)
					print(groups)
					if groups.has(lines_text):
						print(lines_text,3)
						current_line = groups[lines_text]
						print(groups[lines_text])
						start_dialouge()
						return
				current_line = line - 1
				start_dialouge()
				return
			elif line_text.contains("DEFINE localvar["):
				var format1 = line_text.replace("DEFINE localvar[","").replace("]","").split(",")
				var variable_name = format1[0]
				var variable_value = format1[1]
				local_variables[variable_name] = variable_value
				current_line += 1
				start_dialouge()
			elif line_text.contains("DEFINE globalvar["):
				var format1 = line_text.replace("DEFINE globalvar[","").replace("]","").split(",")
				var variable_name = format1[0]
				var variable_value = format1[1]
				global_variables[variable_name] = variable_value
				MagnusTalk._global_vars[variable_name] = variable_value
				current_line += 1
				start_dialouge()
			elif line_text.contains("DELETE localvar["):
				var format1 = line_text.replace("DEFINE localvar[","").replace("]","")
				var variable_name = format1
				local_variables.erase(variable_name)
				current_line += 1
				start_dialouge()
			elif line_text.contains("DELETE globalvar["):
				var format1 = line_text.replace("DEFINE localvar[","").replace("]","")
				var variable_name = format1
				global_variables.erase(variable_name)
				MagnusTalk._global_vars.erase(variable_name)
				current_line += 1
			else:
				for child in options.get_children():
					child.queue_free()
				if line_text.contains("END[]"):
					stop_dialouge()
				button.show()
				options.hide()
				var character : String
				var text
				if line_text.contains("Msound[") && use_audio == true:
					var path = line_text.replace(line_text.split("Msound[")[0],"").replace("]","").replace("Msound[","")
					line_text = line_text.replace("Msound[" + path + "]","")
					audio_output.stream = load(path)
					audio_output.volume_db = audio_volume
					audio_output.play()
				
				if line_text.split(" ")[0].contains("Mchar["):
					var charpre = line_text.split(" ")[0]
					var format2 = charpre.replace("Mchar[","").replace("]","")
					character = format2
					text = line_text.replace("Mchar[" + character + "] ","")
				else:
					character = ""
					text = line_text
				for key in local_variables:
					text = text.replace("GETVAR[" + key + "]",local_variables[key])
				for key in global_variables:
					text = text.replace("GETVAR[" + key + "]",global_variables[key])
				text_output.text = ""
				button.hide()
				character_label.text = "[b]" + character
				triangle.hide()
				text_output.text = text
				var started = false
				if character != "" && use_portraits:
					if FileAccess.file_exists("res://addons/magnustalk/portraits/" + character.to_lower().replace(" ","_") + ".png"):
						character_portrait.texture = load("res://addons/magnustalk/portraits/" + character.to_lower().replace(" ","_") + ".png")
				if use_typing:
					for letter in text_output.get_parsed_text():
						if started == false:
							started = true
							text_output.text = ""
						text_output.text += letter
						if pauses.has(letter):
							await get_tree().create_timer(speed/100 + pause_speed/10).timeout
						else:
							await get_tree().create_timer(speed/100).timeout
				text_output.text = text
				button.show()
				triangle.show()
				print(character + ": " + text)
				if not lines.size() - 1 == current_line:
					if lines[current_line + 1].contains("Mopo[] "):
						current_line += 1
						start_dialouge()
	else:
		stop_dialouge()

func stop_dialouge():
	get_tree().quit()
	box_click = false
	button.hide()
	print("End Dialouge")
	options.hide()
	text_output.text = ""
	character_label.text = ""
	box.hide()


func _on_button_pressed():
	current_line += 1
	start_dialouge()


var check_start
func check_loop(start):
	check_start = start
	if lines[check_line] == "":
		if lines.size() - 1 == check_line:
			return -1
		else:
			check_line += 1
			check_loop(start)
	else:
		return check_line

var readay = true
func _input(event):
	if event is InputEventMouseButton or event.is_action_pressed("ui_accept"):
		if readay:
			if button.visible == true:
				readay = false
				current_line += 1
				start_dialouge()
	else:
		readay = true
