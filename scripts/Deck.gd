class_name Deck extends Node2D

const CARD_SCENE_PATH = "res://scenes/Card.tscn"

signal on_draw_card(card: Card)

var card_models: Array[WyrmCardModel]


# Add cards to bottom of deck - used during play
func insert_card_at_bottom(card: Card):
	card_models.insert(0, card)
	card.queue_free()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_card() -> Card:
	var card_model = card_models.pop_back()
	if not card_model:
		return null
	
	if card_models.size() == 0:
		# TODO: Hanlde disabled states and stuff
		pass
	
	# Instantiate Card
	var card_scene = preload(CARD_SCENE_PATH)
	var card = card_scene.instantiate() as Card
	card.model = card_model
	
	return card

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Parse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Handle draw TODO: Handle disabled if empty
			var top_card = draw_card()
			if top_card:
				add_child(top_card)
				on_draw_card.emit(top_card)
		else:
			# Nothing here
			pass
