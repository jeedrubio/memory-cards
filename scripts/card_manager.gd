extends Node2D

const CHARACTER_COUNT := 721 # Number of available characters

@export var cards_per_row: int
@export var pair_count: int
@export var space_between_cols: int
@export var space_between_rows: int

var _cards: Dictionary[int, Card] = {}
var _selected_card_id: int = 0

signal game_finished()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func generate_random() -> void:
	for i in range(pair_count):
		var char_id = randi_range(1, CHARACTER_COUNT)
		for j in range(2):
			var new_card = Card.create(char_id)
			new_card.card_selected.connect(_on_card_selected)
			new_card.card_unselected.connect(_on_card_unselected)
			_cards[new_card.get_id()] = new_card

func spawn_cards() -> void:
	var card_keys = _cards.keys()
	card_keys.shuffle()

	var curr_row = 0
	var curr_col = 0
	for key in card_keys:
		var c = _cards[key]
		c.position = Vector2(
			curr_col * space_between_cols,
			curr_row * space_between_rows
		)
		curr_col += 1
		if curr_col == cards_per_row:
			curr_col = 0
			curr_row += 1
		add_child(c)

func _on_card_selected(card_id: int) -> void:
	if _selected_card_id == 0:
		_selected_card_id = card_id
		return

	var curr_selected := _cards[_selected_card_id]
	var new_selected := _cards[card_id]
	if card_id == _selected_card_id:
		curr_selected.unselect()
	elif curr_selected.get_char_id() == new_selected.get_char_id():
		curr_selected.reveal()
		new_selected.reveal()
		curr_selected.destroy()
		new_selected.destroy()
		_cards.erase(_selected_card_id)
		_cards.erase(card_id)
		if _cards.size() == 0:
			game_finished.emit()
	else:
		curr_selected.reveal()
		new_selected.reveal()
		curr_selected.unselect()
		new_selected.unselect()

	_selected_card_id = 0

func _on_card_unselected() -> void:
	_selected_card_id = 0
