extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	MagnusTalk.start_dialouge_from_custom_box("res://Dialouge.txt","res://NewBox.tscn")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
