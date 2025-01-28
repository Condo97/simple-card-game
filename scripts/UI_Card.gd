class_name UI_Card extends Control

signal on_tap(ui_card: UI_Card)

const CARD_SCENE_PATH = "res://scenes/Card.tscn"

@onready var card_panel: Panel = $CardPanel

# Instantiation Variables
var card_model: WyrmCardModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_card():
	if card_model:
		var card_scene = preload(CARD_SCENE_PATH)
		var card = card_scene.instantiate() as Card
		card.model = card_model
		card_panel.add_child(card)

			#on_tap.emit(self)


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			on_tap.emit(self)
