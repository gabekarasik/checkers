extends Area2D

@export var cell : Vector2
@onready var piece = get_parent()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_released("click"):
		piece.make_move(cell)
