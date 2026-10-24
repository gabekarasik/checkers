extends Area2D

@export var cell : Vector2
@export var type : String

@onready var cell_scene = load("res://scenes/cell.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var board = get_parent()

@onready var w_moves : Array = [
	Vector2(1, 1),
	Vector2(-1, 1)
]

@onready var b_moves : Array = [
	Vector2(1, -1), 
	Vector2(-1, -1)
]

var moves = []

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_released("click"):
		if board.moving_piece:
			board.moving_piece.hide_moves()
		board.moving_piece = self
		var possible_moves
		if type == "white":
			possible_moves = w_moves
			show_moves(possible_moves)
		elif type == "black":
			possible_moves = b_moves
			show_moves(possible_moves)
			
			
func show_moves(possible_moves):
	for possible_move in possible_moves:
		var new_cell = cell + possible_move
		if !board.occupied.has(new_cell):
			var move_cell = cell_scene.instantiate()
			move_cell.cell = possible_move
			move_cell.position = possible_move * 32
			moves.append(move_cell)
			add_child(move_cell)
			
func hide_moves():
	for move in moves:
		move.queue_free()
	moves = []
	
func make_move(move):
	hide_moves()
	board.occupied.erase(cell)
	cell += move
	board.occupied[cell] = self
	position = cell * 32
