class_name DeckBuilderUI extends Control

# Initialization Variables
var deck_model_identifier: Variant = null
var is_editing: bool = true

signal on_close # Parnet should always update deck view after this emits

const UI_CARD_SCENE_PATH = "res://scenes/UI_Card.tscn"

@onready var card_library_grid_container: GridContainer = $VBoxContainer/HBoxContainer/CardLibrary_ScrollContainer/CardLibrary_GridContainer
@onready var card_library_scroll_container: ScrollContainer = $VBoxContainer/HBoxContainer/CardLibrary_ScrollContainer
@onready var deck_display_grid_container: GridContainer = $VBoxContainer/HBoxContainer/DeckDisplay_ScrollContainer/DeckDisplay_GridContainer
@onready var deck_name_text_edit: TextEdit = $VBoxContainer/Control/DeckName_TextEdit # Parent set to title on initialization
@onready var save_button: Button = $VBoxContainer/Control/SaveButton
@onready var done_button: Button = $VBoxContainer/Control/DoneButton

var has_changes: bool = false # TODO: Better way of detecting changes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load library cards 
	var wyrm_card_library = WyrmDatabase.instance.get_wyrm_card_library()
	if wyrm_card_library:
		for resource in wyrm_card_library.cards:
			var card = resource as WyrmCardModel
			_add_card_to_library(card)
	
	# Get DecksModel
	var decks_model = WyrmDatabase.instance.get_decks_model()
	
	# Load cards and set title from DeckModel if deck_model_id exists in decks_model
	if deck_model_identifier is String:
		var editing_deck_model_index: int = _get_editing_deck_model_index_by_identifier(decks_model.deck_models)
		if editing_deck_model_index >= 0:
			var editing_deck_model: DeckModel = decks_model.deck_models[editing_deck_model_index]
			if editing_deck_model:
				# If editing_deck_model is found and exists set deck_name_text_edit text to title
				deck_name_text_edit.text = editing_deck_model.title
				
				# If editing_deck_model is found and exists add cards to deck
				for card_model in editing_deck_model.cards:
					_add_card_to_deck(card_model)
	
	_update_is_editing_library_showing()
	_update_save_button_state()
	

## Called by parent when creating to add initail cards from deck
#func add_cards_from_deck(deck_model: DeckModel):
	#for card_model in deck_model.cards:
		#_add_card_to_deck(card_model)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_card_to_library(card_model: WyrmCardModel):
	var ui_card_scene = preload(UI_CARD_SCENE_PATH)
	var ui_card = ui_card_scene.instantiate() as UI_Card
	ui_card.card_model = card_model
	ui_card.on_tap.connect(_on_tap_card_in_library)
	card_library_grid_container.add_child(ui_card)

func _add_card_to_deck(card_model: WyrmCardModel):
	var ui_card_scene = preload(UI_CARD_SCENE_PATH)
	var ui_card = ui_card_scene.instantiate() as UI_Card
	ui_card.card_model = card_model
	ui_card.on_tap.connect(_remove_card_from_deck)
	deck_display_grid_container.add_child(ui_card)
	
	if !has_changes:
		has_changes = true # TODO: Better way of detecting changes
		_update_save_button_state()

func _remove_card_from_deck(ui_card: UI_Card):
	ui_card.queue_free()
	
	if !has_changes:
		has_changes = true # TODO: Better way of detecting changes
		_update_save_button_state()

func _on_tap_card_in_library(ui_card: UI_Card):
	# Add card to Deck
	if ui_card.card_model:
		_add_card_to_deck(ui_card.card_model)


func _on_cancel_button_button_up() -> void:
	_dismiss()

func _on_save_button_button_up() -> void:
	# Get DecksModel
	var decks_model = WyrmDatabase.instance.get_decks_model()
	if not decks_model:
		decks_model = DecksModel.new()
	
	# Remove DeckModel with id from _decks_model TODO: Ask if it should save at the same index or not and if so then do an insert at the editing deck model index
	if deck_model_identifier is String:
		var editing_deck_model_index = _get_editing_deck_model_index_by_identifier(decks_model.deck_models)
		if editing_deck_model_index >= 0:
			decks_model.deck_models.remove_at(editing_deck_model_index)
	
	# Create DeckModel
	var deck_model = _create_deck_model()
	
	# Insert at beginning
	decks_model.deck_models.insert(0, deck_model)
	
	# Save decks model
	WyrmDatabase.instance.save_decks_model(decks_model)
	var decks_model2 = WyrmDatabase.instance.get_decks_model()
	
	# Dismiss
	_dismiss()

func _create_deck_model() -> DeckModel:
	# Get card models from cards in deck display h box container
	var card_models: Array[WyrmCardModel]
	for child in deck_display_grid_container.get_children():
		var ui_card = child as UI_Card
		if ui_card:
			if ui_card.card_model:
				card_models.append(ui_card.card_model)
	
	# Create DeckModel and return
	var deck_model = DeckModel.new(
		UUID_Generator.new().as_string(),
		deck_name_text_edit.text,
		card_models
	)
	return deck_model

func _dismiss():
	# Emit on_close and queue_free
	on_close.emit()
	self.queue_free()

func _get_editing_deck_model_index_by_identifier(deck_models: Array[DeckModel]) -> int:
	for i in range(deck_models.size()):
		var deck_model = deck_models[i]
		if deck_model.identifier == deck_model_identifier:
			return i
	return -1

func _update_is_editing_library_showing():
	if is_editing:
		card_library_scroll_container.show()
		save_button.show()
	else:
		card_library_scroll_container.hide()
		save_button.hide()

func _update_save_button_state():
	if has_changes:
		save_button.disabled = false
	else:
		save_button.disabled = true
