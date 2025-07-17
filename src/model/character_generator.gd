extends Node

class_name CharacterGenerator

const RANGE_NB_POSITIVE_ACTIONS = 3
const RANGE_NB_NEGATIVE_ACTIONS = 3

func create_character():
    var nb_positive_actions: int = randi_range(0, RANGE_NB_POSITIVE_ACTIONS)
    var nb_negative_actions: int = randi_range(0, RANGE_NB_NEGATIVE_ACTIONS) if nb_positive_actions else randi_range(1, RANGE_NB_NEGATIVE_ACTIONS)
    var character = Character.new()
    character.label_name = ""
    character.illustration = load("res://icon.svg")
    character.add_actions("Positive", nb_positive_actions)
    character.add_actions("Negative", nb_negative_actions)
    return character
