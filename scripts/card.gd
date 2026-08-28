extends Node2D
class_name Card

var _character_id: int = 0
var _selected: bool = false

signal card_selected(card_id: int)
signal card_unselected()

@onready var front_sprite: Sprite2D = $FrontImage
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	front_sprite.texture = load("res://assets/pokemon/" + str(_character_id) + ".png")

func _process(_delta: float) -> void:
	pass

static func create(char_id: int) -> Card:
	var scene = load("res://scenes/card.tscn")
	var instance: Card = scene.instantiate()
	instance._character_id = char_id
	return instance

func toggle_selection() -> void:
	if _selected:
		unselect()
	else:
		select()

func get_id() -> int:
	return get_instance_id()

func get_char_id() -> int:
	return _character_id

func select() -> void:
	animation_player.queue("select_card")
	_selected = true
	card_selected.emit(get_id())

func unselect() -> void:
	animation_player.queue("unselect_card")
	_selected = false
	card_unselected.emit()

func reveal() -> void:
	animation_player.queue("reveal_card")

func destroy() -> void:
	while animation_player.is_playing() or animation_player.get_queue().size() > 0:
		await animation_player.animation_finished
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_property(self, "rotation", deg_to_rad(45), 0.5)
	await tween.finished
	queue_free()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return

	if not event.button_index == MOUSE_BUTTON_LEFT or not event.pressed:
		return

	if animation_player.get_queue().size() > 0:
		return

	toggle_selection()

func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
