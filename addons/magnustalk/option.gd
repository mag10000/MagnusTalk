extends Button

var jump_to 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var lines_text = jump_to.replace("[","").replace("]","")
	print(lines_text)
	if str(int(jump_to)) != lines_text:
			print(lines_text,2)
			if $"../../..".groups.has(lines_text):
				print(lines_text,3)
				$"../../..".current_line = $"../../..".groups[lines_text]
				print($"../../..".groups[lines_text])
				$"../../..".start_dialouge()
				return
	if int(jump_to) == 0:
		$"../../..".stop_dialouge()
	else:
		$"../../..".current_line = int(jump_to) - 1
		$"../../..".start_dialouge()
