extends Node

class_name CharacterGenerator

var character_illustrations: Array

func _init() -> void:
    character_illustrations = load_character_illustrations()

func create_character(max_positive_actions: int, max_negative_actions: int, max_wrongly_positioned_actions: int,
                        max_nb_deadly_actions: int):
    var nb_positive_actions: int = randi_range(0, max_positive_actions)
    var nb_negative_actions: int = randi_range(0, max_negative_actions) if nb_positive_actions else randi_range(1, max_negative_actions)
    var character = Character.new()
    character.label_name = ""
    character.illustration = character_illustrations[randi_range(0, len(character_illustrations) -1)]
    character.add_actions("Positive", nb_positive_actions)
    character.add_actions("Negative", nb_negative_actions)
    add_mixed_actions(character, max_wrongly_positioned_actions)
    add_deadly_actions(character, max_nb_deadly_actions)
    return character

func load_character_illustrations() -> Array:
    var folder_path = "res://assets/character_illustrations/"
    var illustrations = []
    for file_name in DirAccess.get_files_at(folder_path):
        if not '.import' in file_name:
            if '.png.remap' in file_name: #for game export, because files extension are changed
                file_name = file_name.trim_suffix('.remap')
            illustrations.append(ResourceLoader.load(folder_path + file_name)) 
        elif '.import' in file_name:
            file_name = file_name.trim_suffix('.import')
            illustrations.append(ResourceLoader.load(folder_path + file_name)) 
    return illustrations

func add_mixed_actions(character: Character, max_wrongly_positioned_actions: int):
    var max_wrongly_positioned_positive = randi_range(0, max_wrongly_positioned_actions)
    var max_wrongly_positioned_negative = randi_range(0, max_wrongly_positioned_actions)
    character.add_actions("Positive", max_wrongly_positioned_positive, true)
    character.add_actions("Negative", max_wrongly_positioned_negative, true)

func add_deadly_actions(character: Character, max_nb_deadly_actions: int):
    var nb_actions_array = [0]
    var weights_array = [4./5.]
    var nb_deadly_positive_actions: int = randi_range(0, max_nb_deadly_actions)
    nb_actions_array.append(nb_deadly_positive_actions)
    weights_array.append(1./5.)
    character.add_deadly_actions(nb_actions_array[RandomNumberGenerator.new().rand_weighted(weights_array)])
