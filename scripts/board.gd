extends Node2D

@onready var piece_scene = load("res://scenes/piece.tscn")
@onready var cell_scene = load("res://scenes/cell.tscn")

var occupied : Dictionary = {}
var moving_piece
var turn : String
var capturing_piece
var num_white
var num_black

func _ready() -> void:
	start_game()

func start_game():
	$HUD.hide()
	turn = "black"
	setup_pieces()
	
func setup_pieces():
	place_white()
	place_black()
	num_white = 12
	num_black = 12
	
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
		if num_white == 0:
			end_game("Black")
		turn = "white"
	else:
		if num_black == 0:
			end_game("White")
		turn = "black"
		
func end_game(winner : String):
	$HUD/VBoxContainer/Winner_Label.text = winner + " Wins!"
	$HUD.show()
	
func reset():
	for cell in occupied:
		occupied[cell].queue_free()
	occupied = {}
	
	start_game()
