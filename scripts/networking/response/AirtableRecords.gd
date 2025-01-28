class_name AirtableRecords extends Resource

@export var records: Array[Resource] = []

static func from_json(json_text: String) -> AirtableRecords:
	var result = AirtableRecords.new()
	var json = JSON.parse_string(json_text)
	
	for record_data in json.records:
		var record = AirtableRecord.new()
		record.id = record_data.id
		record.created_time = record_data.createdTime
		record.fields = WyrmsFields.new()
		
		# Process fields
		var fields = record_data.fields
		var ability_names: Array[String] = []
		var ability_descriptions: Array[String] = []
		
		# Handle dynamic ability fields
		for key in fields:
			if "Ability Name" in key:
				var index = key.replace("Ability Name ", "").to_int() - 1
				ability_names.resize(index + 1)
				ability_names[index] = fields[key]
			elif "Ability " in key and " Description" in key:
				var index = key.replace("Ability ", "").replace(" Description", "").to_int() - 1
				ability_descriptions.resize(index + 1)
				ability_descriptions[index] = fields[key]
		
		record.fields.ability_names = ability_names
		record.fields.ability_descriptions = ability_descriptions
		
		# Map other fields
		var field_map = {
			"Attack": "attack",
			"Ability Score": "ability_score",
			"Balance": "balance",
			"Cost": "cost",
			"Title": "title",
			"Short Title": "short_title",
			"Wyrm Type": "wyrm_type",
			"Rarity": "rarity",
			"Defense": "defense"
		}
		
		for json_key in field_map:
			var gd_key = field_map[json_key]
			if json_key in fields:
				record.fields.set(gd_key, fields[json_key])
		
		result.records.append(record)
	
	return result
