class_name Discard extends Node2D

signal on_draw_card(card: Card)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_card(card: Card):
	card.reparent(self)
	card.position = Vector2.ZERO


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Get top card
			var top_card: Card = _get_top_card()
			if top_card:
				on_draw_card.emit(top_card)

func _get_top_card() -> Card:
	for child in get_children():
		if child is Card:
			return child as Card
	return null
