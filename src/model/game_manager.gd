extends Node

var HELL_COMPLETION_RATE := 0.5
var COVER_DEPLETION_RATE := 0.8

var current_character: Character:
    set(value):
        current_character = value
        %GameUI.character = value
var hell_completion: float = 0.:
    set(value):
        hell_completion = value
        if cover_percentage > 0.:
            await %GameUI.update_progress_bar("hell", hell_completion)
            if hell_completion >= 100.:
                victory()
var cover_percentage: float = 100.:
    set(value):
        cover_percentage = value
        await %GameUI.update_progress_bar("cover", cover_percentage)
        if cover_percentage <= 0.:
            defeat()
        detection_threshold *= cover_percentage/100 * 2 #2 is magic number
var detection_threshold: float = 20.
var possible_characters: Array[Character] = []

func _ready() -> void:
    Signals.send_to_heaven.connect(Callable(self, "on_heaven_decision"))
    Signals.send_to_hell.connect(Callable(self, "on_hell_decision"))
    Signals.next_character.connect(Callable(self, "enter_next_character"))
    load_characters()
    current_character = load("res://src/resources/characters/char_test_above.tres")

func load_characters():
    var characters_folder_path = "res://src/resources/characters/"
    for file_name in DirAccess.get_files_at(characters_folder_path):
        if '.tres.remap' in file_name: #for game export, because files extension are changed
            file_name = file_name.trim_suffix('.remap')
        possible_characters.append(ResourceLoader.load(characters_folder_path + file_name)) 

func on_heaven_decision():
    %GameUI.heaven_animation()
    %GameUI.enable_next_character_call()

func on_hell_decision():
        if current_character:
            cover_percentage -= current_character.compute_sum_action_values() * COVER_DEPLETION_RATE if current_character.compute_sum_action_values() > detection_threshold else 0
            hell_completion += current_character.compute_sum_action_values() * HELL_COMPLETION_RATE
            await %GameUI.hell_animation()
            %GameUI.enable_next_character_call()
        else:
            push_warning("Character not attributed")

func enter_next_character():
    current_character = possible_characters[randi_range(0, len(possible_characters) - 1)]

func victory() -> void:
    %GameUI.victory()

func defeat() -> void:
    %GameUI.defeat()
