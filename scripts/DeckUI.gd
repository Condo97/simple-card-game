class_name DeckUI extends Control

# Initialization Variables
var deck_model: DeckModel

signal on_tap(deck_ui: DeckUI)

@onready var deck_name_label: Label = $MarginContainer/ColorRect/VBoxContainer/DeckName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_values():
	if deck_model:
		deck_name_label.text = deck_model.title


func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			on_tap.emit(self)
