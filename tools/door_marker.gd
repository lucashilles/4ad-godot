@tool
extends Marker2D

@export_enum("0", "90", "180", "270") var angle:int = 0:
	set(value):
		angle = value
		rotation_degrees = value * 90

@export_enum("Door", "Passage") var type:int = 0:
	set(value):
		type = value
		_update_arrow()

@onready var door = $Door
@onready var passage = $Passage


func _update_arrow():
	if door != null and passage != null:
		if type > 0:
			passage.visible = true
			door.visible = false
		else:
			passage.visible = false
			door.visible = true
