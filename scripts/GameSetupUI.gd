class_name GameSetupUI extends Control

signal on_close
signal on_start(p1_deck: DeckModel, p2_deck: DeckModel)

const DECK_UI_SCENE_PATH = "res://scenes/DeckUI.tscn"
const SELECT_DECK_LIST_UI_SCENE_PATH = "res://scenes/SelectDeckListUI.tscn"

@onready var deck_area_p1: Control = $View/MarginContainer/VBoxContainer/HBoxContainer/DeckArea_P1
@onready var deck_area_p2: Control = $View/MarginContainer/VBoxContainer/HBoxContainer/DeckArea_P2
@onready var start_button: Button = $View/MarginContainer/VBoxContainer/HBoxContainer2/StartButton
@onready var view = $View

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Update start button state
	_update_start_button_state()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_button_up() -> void:
	# Dismiss
	_dismiss()


func _on_start_button_button_up() -> void:
	var deck_model_p1: DeckModel
	var deck_model_p2: DeckModel
	
	for child in deck_area_p1.get_children():
		var deck = child as DeckUI
		if deck and deck.deck_model:
			deck_model_p1 = deck.deck_model
	for child in deck_area_p2.get_children():
		var deck = child as DeckUI
		if deck and deck.deck_model:
			deck_model_p2 = deck.deck_model
	
	if deck_model_p1 and deck_model_p2:
		on_start.emit(deck_model_p1, deck_model_p2)

func _on_deck_area_color_rect_p_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_show_deck_list_p1()


func _on_deck_area_color_rect_p_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_show_deck_list_p2()


func _show_deck_list_p1() -> void:
	# Show select deck list
	var select_deck_list_ui_scene = preload(SELECT_DECK_LIST_UI_SCENE_PATH)
	var select_deck_list_ui = select_deck_list_ui_scene.instantiate() as SelectDeckListUI
	select_deck_list_ui.on_close.connect(_on_close_subview)
	select_deck_list_ui.on_select_deck.connect(_on_select_deck_p1)
	add_child(select_deck_list_ui)
	
	# Hide view
	view.hide()

func _show_deck_list_p2() -> void:
	# Show select deck list
	var select_deck_list_ui_scene = preload(SELECT_DECK_LIST_UI_SCENE_PATH)
	var select_deck_list_ui = select_deck_list_ui_scene.instantiate() as SelectDeckListUI
	select_deck_list_ui.on_close.connect(_on_close_subview)
	select_deck_list_ui.on_select_deck.connect(_on_select_deck_p2)
	add_child(select_deck_list_ui)
	
	# Hide view
	view.hide()

func _on_close_subview() -> void:
	# Show view
	view.show()

func _on_select_deck_p1(deck_model: DeckModel) -> void:
	# Remove DeckUI from deck_area_p1
	for child in deck_area_p1.get_children():
		if child is DeckUI:
			child.queue_free()
	
	# Add DeckUI with deck_model to deck_area_p1
	var deck_ui_scene = preload(DECK_UI_SCENE_PATH)
	var deck_ui = deck_ui_scene.instantiate() as DeckUI
	deck_ui.deck_model = deck_model
	deck_ui.on_tap.connect(_on_p1_deck_tapped)
	deck_area_p1.add_child(deck_ui)
	
	# Update start button state
	_update_start_button_state()

func _on_select_deck_p2(deck_model: DeckModel) -> void:
	# Remove DeckUI from deck_area_p1
	for child in deck_area_p2.get_children():
		if child is DeckUI:
			child.queue_free()
	
	# Add DeckUI with deck_model to deck_area_p1
	var deck_ui_scene = preload(DECK_UI_SCENE_PATH)
	var deck_ui = deck_ui_scene.instantiate() as DeckUI
	deck_ui.deck_model = deck_model
	deck_ui.on_tap.connect(_on_p2_deck_tapped)
	deck_area_p2.add_child(deck_ui)
	
	# Update start button state
	_update_start_button_state()

func _on_p1_deck_tapped(deck_ui: DeckUI) -> void:
	_show_deck_list_p1()

func _on_p2_deck_tapped(deck_ui: DeckUI) -> void:
	_show_deck_list_p2()

func _dismiss() -> void:
	on_close.emit()
	self.queue_free()

func _update_start_button_state() -> void:
	var deck_p1_exists: bool = false
	var deck_p2_exists: bool = false
	
	for child in deck_area_p1.get_children():
		if child is DeckUI:
			deck_p1_exists = true
			break
	for child in deck_area_p2.get_children():
		if child is DeckUI:
			deck_p2_exists = true
			break
	
	if deck_p1_exists and deck_p2_exists:
		start_button.disabled = false
	else:
		start_button.disabled = true
