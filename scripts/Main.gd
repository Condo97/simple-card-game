class_name Main extends Node2D

const GAME_SCENE_PATH = "res://scenes/Game.tscn"

@onready var main_ui: Main_UI = $CanvasLayer/MainUI

var game: Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to on game start from main_ui
	main_ui.on_start_game.connect(_start_game)
	
	# Show main_ui
	main_ui.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _start_game(deck_p1: DeckModel, deck_p2: DeckModel) -> void:
	# Remove existing game
	if game:
		game.queue_free()
	
	# Create new game
	var game_scene = preload(GAME_SCENE_PATH)
	game = game_scene.instantiate() as Game
	
	game.p1_deck_model = deck_p1
	game.p2_deck_model = deck_p2
	
	add_child(game)
	
	# Set decks in Game
	#game.player_interface_p1.deck.card_models = deck_p1.cards
	#game.player_interface_p2.deck.card_models = deck_p2.cards
	
	# Hide Main_UI
	main_ui.hide()
