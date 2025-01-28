class_name DeckModel extends Resource

@export var identifier: String
@export var title: String
@export var cards: Array[WyrmCardModel]

func _init(identifier: String = "", title: String = "New Deck", cards: Array[WyrmCardModel] = []) -> void:
	self.identifier = identifier
	self.title = title
	self.cards = cards
