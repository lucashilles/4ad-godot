extends Node

const CELL_SIZE := 64

var room_dict: Dictionary
var _counter: int = 0


func _init():
	var file: FileAccess = FileAccess.open("res://4ad-rooms.json", FileAccess.READ)

	if file == null:
		print_debug("Failed loading base game data")

	var room_data = JSON.parse_string(file.get_as_text())

	for r in room_data:
		room_dict[str(r["id"])] = r


func next_id() -> int:
	_counter += 1
	return _counter - 1


func get_room_by_id(id: String) -> Dictionary:
	return room_dict[id]


func get_room_by_type(type: int) -> Array:
	var rooms := []

	for data in room_dict:
		if data["type"] == type:
			rooms.append(data)

	return rooms


func get_room_option_list() -> Array:
	var name_list := []

	for data in room_dict.values():
		name_list.append(str(data["id"]) + " - " + RoomType.name(data["type"]))

	return name_list
