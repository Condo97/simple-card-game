class_name PlayerInterface extends Node2D

# Add card and connect signals
# Handle card hover
# Handle card drag
# Handle card drop

signal on_card_dropped(card: Card, location: Vector2)

@onready var hand: Hand = $Hand

@onready var screen_size: Vector2 = get_viewport_rect().size

var dragging_card: Card = null
var is_hovering_on_card: bool = false
var next_highlight_card: Card = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Drag card
	if dragging_card:
		var mouse_position = get_global_mouse_position()
		dragging_card.position = Vector2(clamp(mouse_position.x, 0, screen_size.x), clamp(mouse_position.y, 0, screen_size.y))

# For draw card signal
func on_card_draw(card: Card):
	add_or_return_card_to_hand(card, true, false)

# For re-add to hand without animation
func add_or_return_card_to_hand(card: Card, move_card: bool, exclude_current_card_from_move: bool):
	# Add card to hand
	hand.add_or_return_card_to_hand(card, move_card, exclude_current_card_from_move)
	
	# Wait so that card is not immediately grabbed from discard because it sends a signal and sometimes it is received
	await get_tree().create_timer(0.1).timeout
	
	# Connect card signals
	_connect_card_signals(card)

func on_card_hover(card: Card):
	if !is_hovering_on_card:
		highlight_card(card)
		is_hovering_on_card = true
	else:
		next_highlight_card = card

func on_card_exit_hover(card: Card):
	if is_hovering_on_card:
		unhighlight_card(card)
		is_hovering_on_card = false
		
		if next_highlight_card and card != next_highlight_card:
			# If next_highlight_card is not card highlight next_highlight_card
			on_card_hover(next_highlight_card)
		# Null next_highlight_card
			next_highlight_card = null

func highlight_card(card: Card):
	card.scale = Vector2(1.05, 1.05)
	card.z_index = 2

func unhighlight_card(card: Card):
	card.scale = Vector2(1, 1)
	card.z_index = 1

func on_card_click(card: Card):
	if card:
		dragging_card = card
	## Determine if should drag
	#if raycast_results.size() > 0:
		## Get highest z-index card
		#var highestCard: Card = get_card_with_highest_z_index(raycast_results)
		#if highestCard:
			#dragging_card = highestCard

func on_card_exit_click(card: Card):
	if dragging_card:
		dragging_card.scale = Vector2(1.05, 1.05)
		# Check if card is in slot by signaling to Game and waiting for a function to be invoked	
		
		on_card_dropped.emit(card, get_global_mouse_position())
	dragging_card = null

## Called by parent after it determines whether or not to put the card in a slot or not
#func add_or_return_card_to_hand(card: Card):
	## Add or return card to hand
	#hand.add_or_return_card_to_hand(card)

# Called by parent after it determines whether or not to put the card in a slot or not
func remove_card_from_hand(card: Card):
	# Disconnect signals
	_disconnect_card_signals(card)
	
	# Update hand position
	hand.update_hand_position(true, null)
	

func get_card_with_highest_z_index(raycast_results: Array[Dictionary]) -> Card:
	var highest_z_card: Card
	for result in raycast_results:
		if result.collider.get_parent() is Card:
			if highest_z_card == null or result.collider.get_parent().z_index > highest_z_card.z_index:
				highest_z_card = result.collider.get_parent()
	return highest_z_card

func _connect_card_signals(card: Card):
	# Attach card signals
	card.on_hover.connect(on_card_hover)
	card.on_exit_hover.connect(on_card_exit_hover)
	card.on_click.connect(on_card_click)
	card.on_exit_click.connect(on_card_exit_click)

func _disconnect_card_signals(card: Card):
	# Attach card signals
	card.on_hover.disconnect(on_card_hover)
	card.on_exit_hover.disconnect(on_card_exit_hover)
	card.on_click.disconnect(on_card_click)
	card.on_exit_click.disconnect(on_card_exit_click)
