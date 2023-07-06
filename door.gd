class_name Door
extends Area2D

var cell_size: int = 64
var collision: CollisionShape2D
var next_room: Room
var orientation: int = 0
var parent_room: Room


func _init(data: Dictionary):
	_create_polygon()
	_create_collision()

	orientation = data["orientation"]
	rotation = deg_to_rad(90 * orientation)

	position = Vector2(data["x"] * cell_size, data["y"] * cell_size * -1)


func _create_polygon():
	var polygon := Polygon2D.new()

	var top_left := Vector2(((cell_size / 2.0) - 8) * -1, -8)
	var bottom_left := Vector2(((cell_size / 2.0) - 8) * -1, 8)
	var top_right := Vector2((cell_size / 2.0) - 8, -8)
	var bottom_right := Vector2((cell_size / 2.0) - 8, 8)

	# Order matteres
	var polygon_vertex := [top_left, bottom_left, bottom_right, top_right]
	polygon.set_polygon(polygon_vertex)

	add_child(polygon)


func _create_collision():
	var shape := RectangleShape2D.new()
	shape.set_size(Vector2(64, 16))

	collision = CollisionShape2D.new()
	collision.set_shape(shape)
	collision.disabled = true

	connect("input_event", _on_input_event)
	add_child(collision)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if next_room == null:
			Ui.handle_new_room(self)
		else:
			print("Return to previous room")


func enable():
	if next_room == null:
		collision.disabled = false


func disable():
	if next_room == null:
		collision.disabled = true


func is_contained_by(polygon: PackedVector2Array) -> bool:
	var door = get_child(0).polygon
	door *= Transform2D(global_transform).inverse()
	print("Door: ", door)
	print("Polygon: ", polygon)
	return Geometry2D.intersect_polygons(door, polygon).size() > 0

func over_board_limits(bounds: Array[PackedVector2Array]) -> bool:
	for bound in bounds:
		var door = get_child(0).polygon
		door *= Transform2D(global_transform).inverse()
		if Geometry2D.intersect_polygons(door, bound).size() > 0:
			return true

	return false
