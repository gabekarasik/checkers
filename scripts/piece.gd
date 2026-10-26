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
var is_king : bool = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if board.moving_piece:
			board.moving_piece.hide_moves()
			if board.moving_piece == self:
				board.moving_piece = null
				return
			board.moving_piece = null
			
		
		if board.turn == type:
			board.moving_piece = self
			var possible_moves
			if type == "white":
				possible_moves = w_moves.duplicate()
				if is_king:
					possible_moves.append_array(b_moves.duplicate())
				show_moves(possible_moves)
				
			elif type == "black":
				possible_moves = b_moves.duplicate()
				if is_king:
					possible_moves.append_array(w_moves.duplicate())
				show_moves(possible_moves)
				
			
			
func show_moves(possible_moves):
	var i = 0
	for possible_move in possible_moves:
		i += 1
		var new_cell = cell + possible_move
		if !board.occupied.has(new_cell):
			var move_cell = cell_scene.instantiate()
			move_cell.cell = possible_move
			move_cell.position = possible_move * 32
			moves.append(move_cell)
			add_child(move_cell)
		else:
			check_capture(new_cell, possible_move)
			

func check_capture(new_cell, possible_move):
	if board.occupied[new_cell].type != type:
		new_cell += possible_move
		possible_move *= 2
		if !board.occupied.has(new_cell):
			var move_cell = cell_scene.instantiate()
			move_cell.cell = possible_move
			move_cell.position = possible_move * 32
			moves.append(move_cell)
			add_child(move_cell)

func hide_moves():
	for move in moves:
		move.call_deferred("queue_free")
	moves = []
	
func make_move(move):
	hide_moves()
	board.occupied.erase(cell)
	cell += move
	board.occupied[cell] = self
	position = cell * 32
	if !is_king:
		check_king()
	board.moving_piece = null
	board.switch_turn()

func capture(move):
	board.occupied[cell + move/2].queue_free()
	board.occupied.erase(cell + move/2)
	make_move(move)

func check_king():
	if type == "white" and cell.y == 7:
		is_king = true
		sprite.region_rect = Rect2(0, 32, 32, 32)
	elif type == "black" and cell.y == 0:
		is_king = true
		sprite.region_rect = Rect2(32, 32, 32, 32)
