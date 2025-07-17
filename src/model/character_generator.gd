extends Node

class_name CharacterGenerator

const RANGE_NB_POSITIVE_ACTIONS = 3
const RANGE_NB_NEGATIVE_ACTIONS = 3

var character_illustrations: Array

func _init() -> void:
    character_illustrations = load_character_illustrations()

func create_character():
    var nb_positive_actions: int = randi_range(0, RANGE_NB_POSITIVE_ACTIONS)
    var nb_negative_actions: int = randi_range(0, RANGE_NB_NEGATIVE_ACTIONS) if nb_positive_actions else randi_range(1, RANGE_NB_NEGATIVE_ACTIONS)
    var character = Character.new()
    character.label_name = ""
    character.illustration = character_illustrations[randi_range(0, len(character_illustrations) -1)]
    character.add_actions("Positive", nb_positive_actions)
    character.add_actions("Negative", nb_negative_actions)
    return character

func load_character_illustrations() -> Array:
    var folder_path = "res://assets/character_illustrations/"
    var illustrations = []
    for file_name in DirAccess.get_files_at(folder_path):
        if not '.import' in file_name:
            if '.png.remap' in file_name: #for game export, because files extension are changed
                file_name = file_name.trim_suffix('.remap')
            illustrations.append(ResourceLoader.load(folder_path + file_name)) 
    return illustrations
