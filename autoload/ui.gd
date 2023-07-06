extends CanvasLayer

@onready var game_ui := preload("res://ui/game_ui.tscn").instantiate()
@onready var pause_menu := preload("res://ui/pause_menu.tscn").instantiate()
@onready var room_select := preload("res://ui/room_select.tscn").instantiate()


func _ready():
	add_child(game_ui)

	pause_menu.hide()
	add_child(pause_menu)

	room_select.hide()
	add_child(room_select)


func pause():
	get_tree().paused = true
	game_ui.hide()
	pause_menu.show()


func resume():
	pause_menu.hide()
	get_tree().paused = false
	game_ui.show()


func cancel_ui():
	for child in get_children():
		child.hide()

	game_ui.show()
	get_tree().paused = false


func handle_new_room(source_door: Door):
	get_tree().paused = true
	game_ui.hide()
	room_select.source_door = source_door
	room_select.show()


func create_room(door: Door, room: Room):
	room_select.hide()
	get_tree().paused = false

	game_ui.show()
	var game_root := get_tree().root.get_node("/root/Game")
	game_root.test(door, room)

	room_select.reset()
