extends Control

var source_door: Door

@onready var option_button = $PanelContainer/MarginContainer/VBoxContainer/OptionButton


func _ready():
	for option in Global.get_room_option_list():
		option_button.add_item(option)


func _unhandled_key_input(event):
	if is_visible_in_tree() and event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed:
			accept_event()
			Ui.cancel_ui()


func _on_button_pressed():
	var selected_id: int = option_button.get_selected_id()
	var option: String = option_button.get_item_text(selected_id)

	var room := Room.new(Global.get_room_by_id(option.split(" - ")[0]))
	Ui.create_room(source_door, room)


func reset():
	source_door = null
	option_button.selected = 0
