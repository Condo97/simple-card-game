# CSVReader.gd
class_name CSVReader extends Object

static func parse_csv(csv_content: String) -> Dictionary:
	var result := {
		"cards": [],
		"treasure_cards": []
	}
	
	var current_section := 0 # 0 = cards, 1 = treasure
	var headers := []
	
	var lines = csv_content.split("\n")
	
	for line in lines:
		line = line.strip_edges()
		if line.is_empty():
			continue
		
		# Check for section separator
		if line.begins_with("$$$"):
			current_section = 1
			headers = [] # Reset headers for new section
			continue
			
		var columns = line.split(",")
		var cleaned_columns = PackedStringArray()
		
		for col in columns:
			cleaned_columns.append(col.strip_edges().replace('"', ''))
		
		if headers.is_empty():
			headers = cleaned_columns
		else:
			match current_section:
				0: # Cards
					result.cards.append(_create_row_dict(headers, cleaned_columns))
				1: # Treasure
					result.treasure_cards.append(_create_row_dict(headers, cleaned_columns))

	return result

static func _create_row_dict(headers: PackedStringArray, columns: PackedStringArray) -> Dictionary:
	var row_dict = {}
	for i in range(min(headers.size(), columns.size())):
		row_dict[headers[i].to_lower()] = columns[i]
	return row_dict
