class_name Main_UI extends Control

signal on_start_game(deck_p1: DeckModel, deck_p2: DeckModel)

#const GAME_UI_SCENE_PATH
const EDIT_DECK_LIST_UI_SCENE_PATH = "res://scenes/EditDeckListUI.tscn"
const GAME_SETUP_UI_SCENE_PATH = "res://scenes/GameSetupUI.tscn"

@onready var view: Control = $"View - parent for hiding when subviews are shown"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_game_button_button_up() -> void:
	# Show game setup
	var game_setup_list_ui_scene = preload(GAME_SETUP_UI_SCENE_PATH)
	var game_setup_list_ui = game_setup_list_ui_scene.instantiate() as GameSetupUI
	game_setup_list_ui.on_close.connect(_on_close_subview)
	game_setup_list_ui.on_start.connect(on_start_game.emit)
	add_child(game_setup_list_ui)
	
	# Hide view
	view.hide()

func _on_edit_decks_button_button_up() -> void:
	# Show deck list
	var edit_deck_list_ui_scene = preload(EDIT_DECK_LIST_UI_SCENE_PATH)
	var edit_deck_list_ui = edit_deck_list_ui_scene.instantiate() as EditDeckListUI
	edit_deck_list_ui.on_close.connect(_on_close_subview)
	add_child(edit_deck_list_ui)
	
	# Hide view
	view.hide()

func _on_close_subview() -> void:
	# Show view
	view.show()
