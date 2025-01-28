class_name SelectDeckListUI extends Control

signal on_close
signal on_select_deck(deck_model: DeckModel)

const DECK_BUILDER_UI_SCENE_PATH = "res://scenes/DeckBuilderUI.tscn"

@onready var deck_with_options_list_ui: DeckWithOptionsListUI = $View/MarginContainer/VBoxContainer/DeckWithOptionsListUI
@onready var view: Control = $View

# This should pull the decks and be able to update, not be supplied with decks

func update_deck_models():
	var decks_model = WyrmDatabase.instance.get_decks_model()
	if not decks_model:
		decks_model = DecksModel.new()
	
	_clear_deck_ui_list()
	for deck_model in decks_model.deck_models:
		_add_deck_ui_to_list(deck_model)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect DeckListUI on_tap_deck signal
	deck_with_options_list_ui.on_tap_deck.connect(_on_tap_deck)
	deck_with_options_list_ui.on_tap_view_deck.connect(_on_tap_view_deck)
	
	update_deck_models()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_deck_ui_to_list(deck_model: DeckModel):
	deck_with_options_list_ui.add_deck(deck_model)

func _clear_deck_ui_list():
	deck_with_options_list_ui.clear_decks()

func _on_tap_deck(deck_ui: DeckUI):
	# Emit on_select_deck and dismiss
	on_select_deck.emit(deck_ui.deck_model)
	_dismiss()

func _on_tap_view_deck(deck_ui: DeckUI):
	_show_deck_builder(deck_ui.deck_model, false)
	

func _on_close_subview():
	# Update deck models
	update_deck_models()
	
	# Show
	view.show()

func _show_deck_builder(deck_model: DeckModel, is_editing: bool):
	# Load and show DeckBuilderUI and hide view
	var deck_builder_ui_scene = preload(DECK_BUILDER_UI_SCENE_PATH)
	var deck_builder_ui = deck_builder_ui_scene.instantiate() as DeckBuilderUI
	deck_builder_ui.on_close.connect(_on_close_subview)
	deck_builder_ui.is_editing = is_editing
	if deck_model and deck_model.identifier:
		deck_builder_ui.deck_model_identifier = deck_model.identifier
	add_child(deck_builder_ui)
	
	# Hide
	view.hide()


func _on_back_button_button_up() -> void:
	# Dismiss
	_dismiss()


func _on_add_deck_button_button_up() -> void:
	# Show deck builder with new deck
	_show_deck_builder(null, true)

func _dismiss():
	# Call on_close and remove
	on_close.emit()
	self.queue_free()
