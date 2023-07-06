class_name Room
extends Node2D

var cell_size: int
var doors: Node2D
var orientation: int = 0:
	set(value):
		orientation = value % 4
		rotation_degrees = value * 90


func _init(room_data: Dictionary, tile_size: int = 64):
	assert(_is_valid_room_data(room_data), "ERROR: Invalid room data")

	name = "Room" + str(room_data["id"]) + "-" + str(Global.next_id())

	cell_size = tile_size
	doors = Node2D.new()
	doors.name = "Doors"

	_add_walls(room_data["walls"])
	_add_doors(room_data["doors"])

	add_child(doors)


func _is_valid_room_data(room_data: Dictionary) -> bool:
	if room_data.is_empty():
		push_error("ERROR: Empty room data")
		return false

	if typeof(room_data["walls"]) == TYPE_ARRAY:
		if room_data["walls"].is_empty():
			push_error("ERROR: Empty wall array")
			return false
	else:
		push_error("ERROR: Invalid walls")
		return false

	if typeof(room_data["doors"]) == TYPE_ARRAY:
		if room_data["doors"].is_empty():
			push_error("ERROR: Empty door array")
			return false
	else:
		push_error("ERROR: Invalid doors")
		return false

	if !room_data["id"]:
		push_error("ERROR: Invalid room id")
		return false

	return true


func _add_walls(walls_data: Array):
	var wall := _create_wall(walls_data)
	wall.name = "Wall"
	add_child(wall)


func _create_wall(vertices: Array) -> Line2D:
	var line := Line2D.new()
	line.width = 4
	line.set_begin_cap_mode(Line2D.LINE_CAP_BOX)

	for vertex in vertices:
		var point := Vector2(vertex["x"] * cell_size, vertex["y"] * cell_size * -1)
		line.add_point(point)

	var point := Vector2(vertices[0]["x"] * cell_size, vertices[0]["y"] * cell_size * -1)
	line.add_point(point)
	return line


func _add_doors(doors_data: Array):
	var n = 0
	for door in doors_data:
		var new_door := Door.new(door)
		new_door.name = "Door" + str(n)
		new_door.parent_room = self
		doors.add_child(new_door)
		n += 1

# TODO: review the usage of this functions
func connect_door(source_door: Door):
	var room: Room = Room.new({})
	var target_door = room.doors.get_children()[0]
	add_child(room)

	var source_room = source_door.parent_room
	var inv_source_door = (source_door.orientation + 2) % 4

	var room_orientation = (
		((4 - target_door.orientation) % 4) + inv_source_door + source_room.orientation
	)
	room.orientation = room_orientation

	var vec = source_door.global_position - target_door.global_position
	room.position += vec


func enable_selection():
	for door in doors.get_children():
		door.enable()


func disable_selection():
	for door in doors.get_children():
		door.disable()


func can_be_placed() -> bool:
	return true


func handle_intersection(_intersections: Array[PackedVector2Array]):
	var room_polygon = get_node("Wall").get_points()
	print(room_polygon)
