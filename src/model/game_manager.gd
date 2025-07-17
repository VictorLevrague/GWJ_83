extends Node

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
var detection_threshold: float = 20.

var character_generator: CharacterGenerator = CharacterGenerator.new()

func _ready() -> void:
    Signals.send_to_heaven.connect(Callable(self, "on_heaven_decision"))
    Signals.send_to_hell.connect(Callable(self, "on_hell_decision"))
    Signals.next_character.connect(Callable(self, "enter_next_character"))
    current_character = character_generator.create_character()

func on_heaven_decision():
    %GameUI.disable_buttons()
    await %GameUI.heaven_animation()
    %GameUI.enable_next_character_call()

func on_hell_decision():
        if current_character:
            print("cover: ", cover_percentage)
            print("threshold: ", detection_threshold)
            print("cover loss: ", convert_action_value_to_cover_completion(current_character.compute_sum_action_values(), detection_threshold))
            cover_percentage -= convert_action_value_to_cover_completion(current_character.compute_sum_action_values(), detection_threshold)
            hell_completion += convert_action_value_to_hell_completion(current_character.compute_sum_action_values())
            print("current_character.compute_sum_action_values(): ", current_character.compute_sum_action_values())
            %GameUI.disable_buttons()
            await %GameUI.hell_animation()
            %GameUI.enable_next_character_call()
        else:
            push_warning("Character not attributed")

func enter_next_character():
    current_character = character_generator.create_character()

func victory() -> void:
    %GameUI.victory()

func defeat() -> void:
    %GameUI.defeat()

func convert_action_value_to_hell_completion(value: float) -> float:
    const VALUE_AT_ORIGIN_BEFORE_ATTENAUTION := 50.
    const SPREAD := 100.
    const HEIGHT = 40.
    const ATTENUATION = 0.4
    return ATTENUATION * (VALUE_AT_ORIGIN_BEFORE_ATTENAUTION + HEIGHT * tanh(value/SPREAD))

func convert_action_value_to_cover_completion(value: float, threshold: float) -> float:
    #For now, you're not punished for letting bad people to heaven (would be with a timer ?)
    #Use sigmoid for bound ?
    const STEEPNESS = 0.6
    return max(0, (value - threshold) * STEEPNESS)
