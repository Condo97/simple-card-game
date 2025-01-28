class_name CharacterCardSlot extends CardSlot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func contains_card() -> bool:
	for child in get_children():
		if child is Card:
			return true
	return false
