extends Area2D

@export var cell : Vector2
@onready var piece = get_parent()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("move", cell)
		piece.make_move(cell)
