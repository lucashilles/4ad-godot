extends Control

@onready var label = $Container/Label


func _process(_delta):
	label.text = str(get_global_mouse_position())


func _on_button_pressed():
	Ui.pause()
