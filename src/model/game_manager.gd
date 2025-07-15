extends Node

var current_character: Character:
    set(value):
        current_character = value
        %GameUI.character = value
var hell_completion: float = 0.:
    set(value):
        hell_completion = value
        %GameUI.update_progress_bar("hell", hell_completion)
var cover_percentage: float = 100.:
    set(value):
        cover_percentage = value
        %GameUI.update_progress_bar("cover", cover_percentage)
var detection_threshold: float = 20.
var possible_characters: Array[Character] = [load("res://src/resources/characters/char_test_above.tres"), 
                                            load("res://src/resources/characters/char_test_below.tres")]

func _ready() -> void:
    Signals.send_to_heaven.connect(Callable(self, "on_heaven_decision"))
    Signals.send_to_hell.connect(Callable(self, "on_hell_decision"))
    current_character = load("res://src/resources/characters/char_test_above.tres")

func on_heaven_decision():
    %GameUI.heaven_animation()
    enter_next_character()

func on_hell_decision():
        if current_character:
            hell_completion += current_character.compute_sum_action_values()
            cover_percentage -= current_character.compute_sum_action_values() if current_character.compute_sum_action_values() > detection_threshold else 0
            await %GameUI.hell_animation()
            enter_next_character()
        else:
            push_warning("Character not attributed")

func enter_next_character():
    current_character = possible_characters[randi_range(0, len(possible_characters) - 1)]
