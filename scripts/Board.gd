class_name Board extends Node2D

signal on_draw_card_from_deck(card: Card)
signal on_draw_card_from_discard(card: Card)

@onready var deck: Deck = $Deck
@onready var deck_slot: CardSlot = $Deck/CardSlot
@onready var discard: Discard = $Discard
@onready var discard_slot: CardSlot = $Discard/CardSlot
@onready var creature_slot_1: CharacterCardSlot = $CreatureSlot1
@onready var creature_slot_2: CharacterCardSlot = $CreatureSlot2
@onready var creature_slot_3: CharacterCardSlot = $CreatureSlot3
@onready var treasure_slot_1: CardSlot = $TreasureSlot1
@onready var treasure_slot_2: CardSlot = $TreasureSlot2
@onready var treasure_slot_3: CardSlot = $TreasureSlot3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.on_draw_card.connect(on_draw_card_from_deck.emit)
	discard.on_draw_card.connect(on_draw_card_from_discard.emit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_slot(location: Vector2) -> CardSlot:
	# Perform raycast to detect if location is in slot
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = location
	parameters.collide_with_areas = true
	var results = space_state.intersect_point(parameters)
	for result in results:
		var slot: CardSlot = result.collider.get_parent() as CardSlot
		if slot:
			return slot
	return null

#func get_empty_slot_at_point(location: Vector2) -> CardSlot:
	## Perform raycast to detect if location is in slot
	#var space_state = get_world_2d().direct_space_state
	#var parameters = PhysicsPointQueryParameters2D.new()
	#parameters.position = location
	#parameters.collide_with_areas = true
	#var results = space_state.intersect_point(parameters)
	#for result in results:
		#var slot: CardSlot = result.collider.get_parent() as CardSlot
		#if slot and slot in get_children():
			#if !slot.contains_card():
				## If slot is found and does not contain card return it
				#return slot
	#return null
