@tool
class_name Card extends Node2D

signal on_hover(card: Card)
signal on_exit_hover(card: Card)
signal on_click(card: Card)
signal on_exit_click(card: Card)

@onready var card_image_sprite: Sprite2D = $"Card Image Sprite"
@onready var cost_label: Label = $Cost
@onready var attack_label: Label = $Attack
@onready var defense_label: Label = $Defense
@onready var card_name_label: Label = $"Card Name"
@onready var card_description_label: Label = $"Card Description"

var model: WyrmCardModel
var starting_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_values()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_values():
	if model:
		# TODO: card_image_sprite
		cost_label.text = str(model.cost)
		attack_label.text = str(model.attack)
		defense_label.text = str(model.defense)
		card_name_label.text = model.title
		card_description_label.text = "" if model.ability_descriptions.size() == 0 else model.ability_descriptions[0]


func _on_area_2d_mouse_entered() -> void:
	on_hover.emit(self)


func _on_area_2d_mouse_exited() -> void:
	on_exit_hover.emit(self)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Emit on_click
			on_click.emit(self)
		else:
			# Emit on_exit_click
			on_exit_click.emit(self)
