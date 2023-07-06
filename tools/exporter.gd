extends Node

@export var id: int = 1
@export_enum("Corridor", "Entrance", "Hall") var type: int = RoomType.ENTRANCE

var text: String = ""

@onready var line_2d = $Line2D
@onready var door = $door


func _ready():
	var walls := []
	for point in line_2d.points:
		var x: int = point.x / 8
		var y: int = abs(point.y) / 8
		var point_dict := {"x": x, "y": y}

		walls.append(point_dict)

	var doors := []
	for mark in door.get_children():
		var orientation = mark.angle

		var x: float = mark.position.x / 8
		var y: float = abs(mark.position.y) / 8
		var door_dict := {"orientation": orientation, "x": x, "y": y}

		doors.append(door_dict)

	var obj := {"id": id, "type": type, "walls": walls, "doors": doors}

	text = JSON.stringify(obj, "", false)

	print(text)
	DisplayServer.clipboard_set(text)
	get_tree().quit()
