extends Node2D

@onready var card_manager: Node2D = $CardManager
@onready var control_node: Control = $Control

func _ready() -> void:
	card_manager.game_finished.connect(_on_game_finished)
	_start_game()

func _process(_delta: float) -> void:
	pass

func _start_game() -> void:
	card_manager.generate_random()
	card_manager.spawn_cards()

func _on_game_finished() -> void:
	control_node.visible = true

func _on_button_pressed() -> void:
	control_node.visible = false
	_start_game()
