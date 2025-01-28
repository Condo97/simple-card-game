# GoogleSheetsDataFetcher.gd
class_name GoogleSheetsDataFetcher extends Node2D

signal csv_data_received(csv_content: String)
signal request_failed(message: String)

@onready var http_request: HTTPRequest = $HTTPRequest

const MAX_REDIRECTS = 5
var redirect_count := 0
var current_url := "https://docs.google.com/spreadsheets/d/e/2PACX-1vR7CTCkP6ZEdPEfD9ZMEWkjU8MzYWtIfFvyOtyVhcXc_fsf2imL38d0Tl2d1RqE_R44DD86ahesX1Ij/pub?gid=585748874&single=true&output=csv"

func _ready():
	http_request.request_completed.connect(_on_request_completed)

func fetch_csv_data():
	redirect_count = 0
	_make_request(current_url)

func _make_request(url: String):
	var headers = [
		"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
		"Accept: text/csv"
	]
	
	var error = http_request.request(url, headers)
	if error != OK:
		request_failed.emit("Failed to initiate request to: %s" % url)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result == HTTPRequest.RESULT_SUCCESS:
		match response_code:
			HTTPClient.RESPONSE_OK:
				_handle_successful_response(headers, body)
			HTTPClient.RESPONSE_TEMPORARY_REDIRECT, \
			HTTPClient.RESPONSE_MOVED_PERMANENTLY:
				_handle_redirect(response_code, headers)
			_:
				request_failed.emit("Unexpected response code: %d" % response_code)
	else:
		request_failed.emit("Request failed with result code: %d" % result)

func _handle_successful_response(headers: PackedStringArray, body: PackedByteArray):
	var content_type = _get_header_value(headers, "Content-Type")
	if "text/csv" in content_type:
		csv_data_received.emit(body.get_string_from_utf8())
	else:
		request_failed.emit("Received non-CSV content type: %s" % content_type)

func _handle_redirect(response_code: int, headers: PackedStringArray):
	if redirect_count >= MAX_REDIRECTS:
		request_failed.emit("Too many redirects (%d)" % redirect_count)
		return
	
	var location = _get_header_value(headers, "Location")
	if location.is_empty():
		request_failed.emit("Redirect with no Location header")
		return
	
	redirect_count += 1
	current_url = location
	_make_request(location)

func _get_header_value(headers: PackedStringArray, header_name: String) -> String:
	for header in headers:
		if header.to_lower().begins_with(header_name.to_lower() + ":"):
			return header.split(":", false, 1)[1].strip_edges()
	return ""
