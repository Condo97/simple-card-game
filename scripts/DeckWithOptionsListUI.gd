class_name DeckWithOptionsListUI extends Control

signal on_tap_deck(deck_ui: DeckUI)
signal on_tap_view_deck(deck_ui: DeckUI)

const DECK_WITH_OPTIONS_UI_SCENE_PATH = "res://scenes/DeckWithOptionsUI.tscn"

@onready var deck_list_h_box_container: HBoxContainer = $ScrollContainer/DeckList_HBoxContainer

func add_deck(deck_model: DeckModel):
	var deck_with_options_ui_scene = preload(DECK_WITH_OPTIONS_UI_SCENE_PATH)
	var deck_with_options_ui = deck_with_options_ui_scene.instantiate() as DeckWithOptionsUI
	deck_with_options_ui.deck_model = deck_model
	deck_with_options_ui.on_tap_deck.connect(on_tap_deck.emit)
	deck_with_options_ui.on_tap_view_deck.connect(on_tap_view_deck.emit)
	deck_list_h_box_container.add_child(deck_with_options_ui)

func clear_decks():
	for child in deck_list_h_box_container.get_children():
		child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
