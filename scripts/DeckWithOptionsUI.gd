class_name DeckWithOptionsUI extends Control

# Initialization Variables
var deck_model: DeckModel

signal on_tap_deck(deck_ui: DeckUI)
signal on_tap_view_deck(deck_ui: DeckUI)

@onready var deck_ui: DeckUI = $VBoxContainer/DeckUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_ui.on_tap.connect(on_tap_deck.emit)
	deck_ui.deck_model = deck_model
	deck_ui.update_values()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_view_deck_button_button_up() -> void:
	on_tap_view_deck.emit(deck_ui)
