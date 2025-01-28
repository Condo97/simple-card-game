class_name Game extends Node2D

# Initialization Variables
var p1_deck_model: DeckModel
var p2_deck_model: DeckModel

@onready var player_interface_p1: PlayerInterface = $PlayerInterface_p1
@onready var player_interface_p2: PlayerInterface = $PlayerInterface_p2
@onready var board_p1: Board = $Board_p1
@onready var board_p2: Board = $Board_p2

@onready var player_1_board_location: Vector2 = board_p1.position
@onready var player_2_board_location: Vector2 = board_p2.position

enum Players {
	PLAYER_1,
	PLAYER_2
}

var active_player: Players = Players.PLAYER_1
var active_player_interface: PlayerInterface # This could be a computed value if it was possible but idk I need to research it more
var active_board: Board # This could be computed too


func on_card_dropped(card: Card, location: Vector2):
	# Determine if the card is dropped on a character board slot, treasure board slot, discard, or deck
	var slot = active_board.get_slot(location)
	if card is Card and slot and slot is CharacterCardSlot:
		# Put card in slot and call remove_card_from_hand in active_player_interface
		card.reparent(slot)
		card.position = Vector2.ZERO
		active_player_interface.remove_card_from_hand(card)
		
		# Connect card click to _on_card_click
		card.on_click.connect(_on_card_click)
	elif slot == active_board.discard_slot:
		active_board.discard.add_card(card)
		active_player_interface._disconnect_card_signals(card)
	elif slot == active_board.deck_slot:
		# If deck slot return card to deck
		# TODO: Return card to deck
		active_board.deck.insert_card_at_bottom(card)
	else:
		# Move card back to hand
		# Call add_or_return_card_to_hand in active_player_interface
		active_player_interface.add_or_return_card_to_hand(card, true, false)
	

func set_active_player(player: Players):
	flip_boards(player, 0.2)
	
	if player == Players.PLAYER_2:
		# Swap interface visibility
		player_interface_p1.visible = false
		player_interface_p2.visible = true
		
		# Set active player, player interface, and board
		active_player = Players.PLAYER_2
		active_player_interface = player_interface_p2
		active_board = board_p2
	else:
		# Swap interface visibility
		player_interface_p2.visible = false
		player_interface_p1.visible = true
		
		# Set active player, player interface, and board
		active_player = Players.PLAYER_1
		active_player_interface = player_interface_p1
		active_board = board_p1

func flip_boards(active_player: Players, speed: float):
	var tween = get_tree().create_tween()
	tween.tween_property(board_p1, "position", player_2_board_location if active_player == Players.PLAYER_2 else player_1_board_location, speed)
	tween.tween_property(board_p1, "rotation", deg_to_rad(180) if active_player == Players.PLAYER_2 else 0, speed)
	tween.tween_property(board_p2, "position", player_1_board_location if active_player == Players.PLAYER_2 else player_2_board_location, speed)
	tween.tween_property(board_p2, "rotation", 0 if active_player == Players.PLAYER_2 else deg_to_rad(180), speed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to events
	player_interface_p1.on_card_dropped.connect(on_card_dropped)
	player_interface_p2.on_card_dropped.connect(on_card_dropped)
	
	board_p1.on_draw_card_from_deck.connect(player_interface_p1.on_card_draw)
	board_p2.on_draw_card_from_deck.connect(player_interface_p2.on_card_draw)
	
	board_p1.on_draw_card_from_discard.connect(player_interface_p1.on_card_draw)
	board_p2.on_draw_card_from_discard.connect(player_interface_p2.on_card_draw)
	
	# Set active player
	set_active_player(Players.PLAYER_1)
	
	# Set decks
	board_p1.deck.card_models = p1_deck_model.cards
	board_p2.deck.card_models = p2_deck_model.cards

func _on_card_click(card: Card):
	# Ensure card is in current board TODO: Is this appropriate and good enough? Fast enough?
	var contained: bool = false
	for child in active_board.get_children():
		if card in child.get_children():
			contained = true
			break
	if !contained:
		return
		
	# Disconnect card on click signal
	card.on_click.disconnect(_on_card_click)
	
	# Call on_card_draw to reparent and connect signals
	#active_player_interface.on_card_draw(card)
	active_player_interface.add_or_return_card_to_hand(card, true, true)
	active_player_interface.on_card_click(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_change_player_button_button_up() -> void:
	# Change player
	if active_player == Players.PLAYER_1:
		set_active_player(Players.PLAYER_2)
	else:
		set_active_player(Players.PLAYER_1)
