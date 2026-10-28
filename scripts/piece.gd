extends Area2D

@export var cell : Vector2
@export var type : String

@onready var cell_scene = load("res://scenes/cell.tscn")
@onready var sprite: Sprite2D = $Sprite2D
@onready var board = get_parent()

var w_moves : Array = [
	Vector2(1, 1),
	Vector2(-1, 1)
]

var b_moves : Array = [
	Vector2(1, -1), 
	Vector2(-1, -1)
]

@onready var all_moves : Array =  w_moves + b_moves

var moves = []
var is_king : bool = false
var just_captured = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if board.capturing_piece:
			end_turn()
			return
		
		if board.moving_piece:
			board.moving_piece.hide_moves()
			if board.moving_piece == self:
				board.moving_piece = null
				return
			board.moving_piece = null
		
		if board.turn == type:
			check_moves()
			
func check_moves():
	board.moving_piece = self
	var possible_moves
	if is_king:
		possible_moves = all_moves
	elif type == "white":
		possible_moves = w_moves
	elif type == "black":
		possible_moves = b_moves
		
	show_moves(possible_moves)
		
func show_moves(possible_moves):
	for possible_move in possible_moves:
		var new_cell = cell + possible_move
		if new_cell.x >= 0 and new_cell.x <= 7 and new_cell.y >= 0 and new_cell.y <= 7:
			if !board.occupied.has(new_cell):
				if !just_captured:
					var move_cell = cell_scene.instantiate()
					move_cell.cell = possible_move
					move_cell.position = possible_move * 32
					moves.append(move_cell)
					add_child(move_cell)
			else:
				check_capture(new_cell, possible_move)
	
	if just_captured and !moves:
		end_turn()

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
	
	if !just_captured:
		end_turn()
	else:
		check_moves()

func capture(move):
	if type == "black":
		board.num_white -= 1
	else:
		board.num_black -= 1
	just_captured = true
	board.capturing_piece = self
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

func end_turn():
	if board.capturing_piece:
		board.capturing_piece.hide_moves()
		board.capturing_piece.just_captured = false
		
	board.capturing_piece = null
	board.moving_piece = null
	board.switch_turn()
