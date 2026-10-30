extends CanvasLayer

signal replay



func _on_replay_button_pressed() -> void:
	replay.emit()
