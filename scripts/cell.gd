extends Area2D

@export var cell : Vector2
@onready var piece = get_parent()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not event.is_echo():
		if abs(cell.x / 2) == 1:
			piece.capture(cell)
		else:
			piece.make_move(cell)
