class_name RoomType

enum { CORRIDOR, ENTRANCE, HALL }


static func name(value: int) -> String:
	var names := {CORRIDOR: "CORRIDOR", ENTRANCE: "ENTRANCE", HALL: "HALL"}

	return names[value]
