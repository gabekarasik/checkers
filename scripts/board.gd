extends Node2D

@onready var piece_scene = load("res://scenes/piece.tscn")
@onready var cell_scene = load("res://scenes/cell.tscn")

var occupied : Dictionary = {}
var moving_piece
var turn : String

func _ready() -> void:
	setup_pieces()
	turn = "black"

func setup_pieces():
	place_white()
	place_black()
	
func place_white():
	var x = 1
	var piece
	
	for y in range(3):
		for i in range(4):
			piece = piece_scene.instantiate()
			piece.type = "white"
			piece.cell = Vector2(x, y)
			piece.position = piece.cell * 32
			occupied[piece.cell] = piece
			add_child(piece)
			if x == 7:
				x %= 7
			else:
				x += 2
				if x != 7:
					x %= 7
					

func place_black():
	var x = 0
	var piece
	
	for y in range(5, 8):
		for i in range(4):
			piece = piece_scene.instantiate()
			piece.type = "black"
			
			piece.cell = Vector2(x, y)
			piece.position = piece.cell * 32
			occupied[piece.cell] = piece
			add_child(piece)
			piece.sprite.region_rect = Rect2(32, 0, 32, 32)
			if x == 7:
				x %= 7
			else:
				x += 2
				if x != 7:
					x %= 7
		
func switch_turn():
	if turn == "black":
		turn = "white"
	else:
		turn = "black"
	print(turn)
