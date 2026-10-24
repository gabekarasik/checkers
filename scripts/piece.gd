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
				print("registered as same")
				board.moving_piece = null
				return
			board.moving_piece = null
			
		
		if board.turn == type:
			board.moving_piece = self
			var possible_moves
			if type == "white":
				print("trying white")
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
		move.call_deferred("queue_free")
	moves = []
	
func make_move(move):
	print(cell)
	hide_moves()
	board.occupied.erase(cell)
	cell += move
	print(cell)
	board.occupied[cell] = self
	position = cell * 32
	check_king()
	board.moving_piece = null
	board.switch_turn()

func check_king():
	if type == "white" and cell.y == 7:
		is_king = true
		sprite.region_rect = Rect2(0, 32, 32, 32)
