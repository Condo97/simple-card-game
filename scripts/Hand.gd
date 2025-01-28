class_name Hand extends Node2D

const CARD_WIDTH = 600
const HAND_Y_BOTTOM_OFFSET = 1000

const ANIMATION_SPEED: float = 0.2

var center_screen_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_or_return_card_to_hand(card: Card, move_cards: bool, exclude_current_card_from_move: bool):
	if card in get_children():
		# Moves the card to its starting_position from wherever 
		if move_cards and not exclude_current_card_from_move:
			animate_return_card_to_hand(card)
	else:
		# Reparents the card, updates its starting_position, and animates it to its new starting_position
		_add_card_to_hand(card, move_cards, exclude_current_card_from_move)
		if move_cards and not exclude_current_card_from_move:
			animate_return_card_to_hand(card)

func animate_return_card_to_hand(card: Card):
	_animate_card_to_position(card, card.starting_position, ANIMATION_SPEED)
		
func update_hand_position(move_cards: bool, exclude: Card, speed: float = ANIMATION_SPEED):
	var cards: Array[Node] = get_children().filter(func(n): return n is Card)
	for i in range(cards.size()):
		var new_position = Vector2(_calculate_card_x_position(i, cards.size()), get_viewport_rect().size.y - HAND_Y_BOTTOM_OFFSET)
		var card = cards[i]
		card.starting_position = new_position
		if move_cards and not card == exclude:
			animate_return_card_to_hand(card)

func _add_card_to_hand(card: Card, move_cards: bool, exclude_current_card_from_move: bool):
	# Reparent card to Hand
	card.reparent(self)
	
	# Update hand position
	var exclude_card: Card = null
	if exclude_current_card_from_move:
		exclude_card = card
	
	update_hand_position(move_cards, exclude_card)

func _calculate_card_x_position(index: int, card_count: int):
	var total_width = (card_count - 1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func _animate_card_to_position(card: Card, new_position: Vector2, speed: float):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
