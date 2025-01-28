class_name WyrmDatabase extends Node2D

static var instance: WyrmDatabase

const WYRM_LOCATION = "user://wyrm_library.res"
const TREASURE_LOCATION = "user://treasure_library.res"
const DECKS_MODEL_LOCATION = "user://decks_model.res"

@onready var google_sheets_data_fetcher: GoogleSheetsDataFetcher = $GoogleSheetsDataFetcher

func _init() -> void:
	instance = self
	
func _ready():
	google_sheets_data_fetcher.csv_data_received.connect(_on_csv_data_received)
	google_sheets_data_fetcher.request_failed.connect(_on_request_failed)
	download_save_wyrms()

func _on_request_failed(message: String):
	print("CSV download failed: ", message)

func download_save_wyrms():
	google_sheets_data_fetcher.fetch_csv_data()

func save_wyrm_card_library(wyrm_card_library: WyrmCardLibrary):
	ResourceSaver.save(wyrm_card_library, WYRM_LOCATION)

func get_wyrm_card_library() -> WyrmCardLibrary:
	return ResourceLoader.load(WYRM_LOCATION)

func save_treasure_card_library(treasure_library: TreasureCardLibrary):
	ResourceSaver.save(treasure_library, TREASURE_LOCATION)

func get_treasure_card_library() -> TreasureCardLibrary:
	return ResourceLoader.load(TREASURE_LOCATION)

func save_decks_model(decks_model: DecksModel):
	ResourceSaver.save(decks_model, DECKS_MODEL_LOCATION)

func get_decks_model() -> DecksModel:
	return ResourceLoader.load(DECKS_MODEL_LOCATION)

func _on_csv_data_received(csv_content: String):
	var parsed_data = CSVReader.parse_csv(csv_content)
	
	# Process Wyrm Cards
	var wyrm_library = WyrmCardLibrary.new()
	wyrm_library.cards = _parse_wyrm_cards(parsed_data.get("cards", []))
	save_wyrm_card_library(wyrm_library)
	
	# Process Treasure Cards
	var treasure_library = TreasureCardLibrary.new()
	treasure_library.cards = _parse_treasure_cards(parsed_data.get("treasure_cards", []))
	save_treasure_card_library(treasure_library)

func _parse_wyrm_cards(rows: Array) -> Array[WyrmCardModel]:
	var cards: Array[WyrmCardModel] = []
	for row in rows:
		var card = _create_card_from_row(row)
		if card:
			cards.append(card)
	return cards

func _parse_treasure_cards(rows: Array) -> Array[TreasureCardModel]:
	var treasures: Array[TreasureCardModel] = []
	for row in rows:
		var treasure = _create_treasure_from_row(row)
		if treasure:
			treasures.append(treasure)
	return treasures

func _create_card_from_row(row: Dictionary) -> WyrmCardModel:
	var card = WyrmCardModel.new()
	var valid = false
	
	for field in row:
		var value = row[field]
		match field.to_lower():
			"name":
				card.name = value
			"attack":
				card.attack = value.to_int()
				valid = true
			"ability_score":
				card.ability_score = value.to_int()
			"cost":
				card.cost = value.to_int()
			"title":
				card.title = value
			"short_title":
				card.short_title = value
			"wyrm_type":
				card.wyrm_type = value
			"rarity":
				card.rarity = value
			"defense":
				card.defense = value.to_int()
			"ability_names":
				card.ability_names = value.split(";") if value else []
			"ability_descriptions":
				card.ability_descriptions = value.split(";") if value else []
	
	return card if valid else null

func _create_treasure_from_row(row: Dictionary) -> TreasureCardModel:
	var treasure = TreasureCardModel.new()
	var valid = false
	
	for field in row:
		var value = row[field]
		match field.to_lower():
			"name":
				treasure.name = value
				valid = true  # Consider name mandatory for validity
			"treasure amount":
				treasure.treasure_amount = value.to_int()
	
	return treasure if valid else null
