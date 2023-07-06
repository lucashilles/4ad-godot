extends Node2D

const CELL_SIZE := 64

var active_room: Room
var new_room: Room
var dungeon_shape: Polygon2D

@onready var camera := $Camera2D


func _ready():
	dungeon_shape = Polygon2D.new()
	dungeon_shape.name = "DungeonShape"
	dungeon_shape.set_color(Color("gray", 0.2))
	add_child(dungeon_shape)

	active_room = Room.new(Global.get_room_by_id("3"))
	active_room.enable_selection()
	add_child(active_room)

	# polygon
	var active_points = active_room.get_child(0).get_points()
	dungeon_shape.set_polygon(active_points)


func _process(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	camera.position += input_direction * 50


func _on_button_pressed(source_door: Door, room: Room):
	var target_door = room.doors.get_children()[0]
	add_child(room)

	var source_room = source_door.parent_room
	target_door.next_room = source_room
	var inv_source_door = (source_door.orientation + 2) % 4

	var room_orientation = (
		((4 - target_door.orientation) % 4) + inv_source_door + source_room.orientation
	)
	room.orientation = room_orientation

	var vec = Vector2i(source_door.global_position - target_door.global_position)
	room.position += Vector2(vec)

	#Polygon area
	do_polygon_stuf(room)

	active_room.disable_selection()
	room.enable_selection()
	active_room = room


func test(door: Door, room: Room):
	_on_button_pressed(door, room)

# TODO: Refactor and move to Room class
func do_polygon_stuf(room: Room):
	# Polygon area
	var new_polygon = room.get_child(0).get_points()
	new_polygon *= Transform2D(room.global_transform).inverse()

	# Round points
	for i in range(new_polygon.size()):
		new_polygon.set(i, new_polygon[i].round())

	var dungeon_polygon = dungeon_shape.get_polygon()
	var intersections := Geometry2D.intersect_polygons(dungeon_polygon, new_polygon)

	# TODO: move to Room class, shouldnt be called here
	for door in room.doors.get_children():
		if door.next_room == null and door.over_board_limits(get_child(0).bounds):
			door.queue_free()

	if not intersections.is_empty():
		handle_intersection(intersections, new_polygon, room)

		# Debug: show intersections
		for intersection in intersections:
			var intersected_polygon = Polygon2D.new()
			intersected_polygon.name = "Collision"
			intersected_polygon.set_color(Color("red"))
			intersected_polygon.set_polygon(intersection)
			add_child(intersected_polygon)
	else:
		var merged_polygon = Geometry2D.merge_polygons(dungeon_polygon, new_polygon)
		dungeon_shape.set_polygon(merged_polygon[0])


func handle_intersection(
	intersections: Array[PackedVector2Array], room_poly: PackedVector2Array, room: Room
):
	var clipped: Array[PackedVector2Array]
	for intersection in intersections:
		clipped = Geometry2D.clip_polygons(room_poly, intersection)

	var main_area: PackedVector2Array
	var main_door: Door = room.doors.get_children()[0]
	for clip in clipped:
		if main_door.is_contained_by(clip):
			main_area = clip
			break

	for door in room.doors.get_children():
		if door.next_room == null and not door.is_contained_by(main_area):
			door.queue_free()

	print("Clipping")
	# Debug: show remaining polygons
	var intersected_polygon = Polygon2D.new()
	intersected_polygon.name = "ValidRoom"
	intersected_polygon.set_color(Color("blue"))
	intersected_polygon.set_polygon(main_area)
	add_child(intersected_polygon)

	main_area *= Transform2D(room.global_transform)
	for i in range(main_area.size()):
		main_area.set(i, main_area[i].round())

	main_area.append(Vector2(main_area[0].x, main_area[0].y))
	room.get_child(0).set_points(main_area)
