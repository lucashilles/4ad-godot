extends Node

@export var height: int = 28
@export var width: int = 20

var bounds: Array[PackedVector2Array] = []
var _border := Global.CELL_SIZE * 8

@onready var h_label := $HLabel
@onready var v_label := $VLabel

func _ready():
	for i in range(2, width + 1):
		var new_h_label := h_label.duplicate(DUPLICATE_USE_INSTANTIATION)
		var base_position: Vector2 = h_label.get_position()
		base_position.x = 64 * i
		new_h_label.set_position(base_position)
		new_h_label.set_text(str(i))
		add_child(new_h_label)

	for i in range(2, height + 1):
		var new_v_label := v_label.duplicate(DUPLICATE_USE_INSTANTIATION)
		var base_position: Vector2 = v_label.get_position()
		base_position.y = 64 * -i
		new_v_label.set_position(base_position)
		new_v_label.set_text(str(i))
		add_child(new_v_label)

	_create_bounds()

func _create_bounds():
	var total_height := Global.CELL_SIZE * height * -1
	var total_width := Global.CELL_SIZE * width

	var left_bound := PackedVector2Array()
	left_bound.append(Vector2(0, _border))
	left_bound.append(Vector2(0, _border * -1 + total_height))
	left_bound.append(Vector2(_border * -1, _border * -1 + total_height))
	left_bound.append(Vector2(_border * -1, _border))
	bounds.append(left_bound)

	var right_bound := PackedVector2Array()
	right_bound.append(Vector2(total_width + _border, _border))
	right_bound.append(Vector2(total_width + _border, _border * -1 + total_height))
	right_bound.append(Vector2(total_width, _border * -1 + total_height))
	right_bound.append(Vector2(total_width, _border))
	bounds.append(right_bound)

	var top_bound := PackedVector2Array()
	top_bound.append(Vector2(total_width, total_height))
	top_bound.append(Vector2(total_width, _border * -1 + total_height))
	top_bound.append(Vector2(0, _border * -1 + total_height))
	top_bound.append(Vector2(0, total_height))
	bounds.append(top_bound)

	var bottom_bound := PackedVector2Array()
	bottom_bound.append(Vector2(total_width, _border))
	bottom_bound.append(Vector2(total_width, 0))
	bottom_bound.append(Vector2(0, 0))
	bottom_bound.append(Vector2(0, _border))
	bounds.append(bottom_bound)
