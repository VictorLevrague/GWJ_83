extends Node

var current_character: Character:
    set(value):
        current_character = value
        %GameUI.character = value
var hell_completion: float = 0.:
    set(value):
        hell_completion = value
        await %GameUI.update_progress_bar("hell", hell_completion)
var cover_percentage: float = 100.:
    set(value):
        cover_percentage = value
        await %GameUI.update_progress_bar("cover", cover_percentage)
var detection_threshold: float = 10.

var nb_persons_to_hell_to_complete_level: int
var total_nb_persons_to_judge: int
var max_positive_actions_per_character: int
var max_negative_actions_per_character: int
var max_wrongly_positioned_actions_per_character: int
var max_nb_deadly_actions: int
var cover_loss_multiplier: float
var maximum_cover_loss: float

var nb_persons_judged: int = 0
var current_level = 0

var character_generator: CharacterGenerator = CharacterGenerator.new()

func _ready() -> void:
    Signals.send_to_heaven.connect(Callable(self, "on_heaven_decision"))
    Signals.send_to_hell.connect(Callable(self, "on_hell_decision"))
    Signals.next_character.connect(Callable(self, "enter_next_character"))
    Signals.next_level.connect(Callable(self, "next_level"))
    Signals.restart_level.connect(Callable(self, "restart_level"))
    next_level()
    %GameUI.update_people_to_judge_label(nb_persons_judged, total_nb_persons_to_judge)

func are_people_left_to_judge():
    return (total_nb_persons_to_judge - nb_persons_judged) > 0

func on_heaven_decision():
    nb_persons_judged += 1
    %GameUI.update_people_to_judge_label(nb_persons_judged, total_nb_persons_to_judge)
    %GameUI.disable_buttons()
    await %GameUI.heaven_animation()
    for action in current_character.negative_actions:
        if action.automatic_destination == "hell":
            cover_percentage = 0
            defeat("Cover_loss")
            return
    if are_people_left_to_judge():
        %GameUI.enable_next_character_call()
    else:
        defeat("No_people_left_to_judge")

func on_hell_decision():
    if current_character:
        nb_persons_judged += 1
        %GameUI.update_people_to_judge_label(nb_persons_judged, total_nb_persons_to_judge)
        modify_player_values()
        %GameUI.disable_buttons()
        await %GameUI.hell_animation()
        for action in current_character.positive_actions:
            if action.automatic_destination == "heaven":
                cover_percentage = 0
        if cover_percentage <= 0.:
            defeat("Cover_loss")
            return
        if hell_completion >= 100.:
            victory()
            return
        if are_people_left_to_judge():
            %GameUI.enable_next_character_call()
        else:
            defeat("No_people_left_to_judge")
    else:
        push_warning("Character not attributed")

func modify_player_values():
    var total_action_value := current_character.compute_sum_action_values()
    var cover_loss = convert_action_value_to_cover_completion(total_action_value, detection_threshold, cover_loss_multiplier)
    if cover_loss > maximum_cover_loss:
        cover_loss = maximum_cover_loss
    cover_percentage -= cover_loss
    #hell_completion += convert_action_value_to_hell_completion(total_action_value)
    hell_completion += 100/nb_persons_to_hell_to_complete_level
    #await set_hell_completion(hell_completion + 100 / nb_persons_to_hell_to_complete_level)
    detection_threshold = max(0, detection_threshold - convert_action_value_to_detection_threshold_loss(total_action_value))

func enter_next_character():
    if are_people_left_to_judge():
        current_character = character_generator.create_character(max_positive_actions_per_character, max_negative_actions_per_character,
                                                                max_wrongly_positioned_actions_per_character, max_nb_deadly_actions)
    else:
        defeat("No_people_left_to_judge")

func victory() -> void:
    if current_level == 5:
        endgame()
        return
    %GameUI.victory()
    %GameUI.get_node("%NextLevelLayer").show()

func defeat(type: String) -> void:
    %GameUI.defeat(type)

func next_level():
    reset_level_stats()
    current_level += 1
    update_level_characteristics(current_level)
    %GameUI.update_people_to_judge_label(nb_persons_judged, total_nb_persons_to_judge)
    %GameUI.next_level(current_level)
    %GameUI.enter_new_character()

func convert_action_value_to_hell_completion(value: float) -> float:
    #tanh
    const VALUE_AT_ORIGIN_BEFORE_ATTENAUTION := 50.
    const SPREAD := 100.
    const HEIGHT = 40.
    const ATTENUATION = 0.4
    return ATTENUATION * (VALUE_AT_ORIGIN_BEFORE_ATTENAUTION + HEIGHT * tanh(value/SPREAD))

func convert_action_value_to_cover_completion(value: float, threshold: float, steepness: float) -> float:
    #ReLu (Rectified Linear Unit) function
    #For now, you're not punished for letting bad people to heaven (would be with a timer ?)
    #Use sigmoid for bound ?
    return max(0, (value - threshold) * steepness)

func convert_action_value_to_detection_threshold_loss(value: float):
    #Sigmoid
    const MAXIMUM:= 90.
    const STEEPNESS := 0.18
    const X_SHIFT := 35.
    return MAXIMUM / (1 + exp(-STEEPNESS*(value - X_SHIFT)))

func reset_level_stats():
    nb_persons_judged = 0
    hell_completion = 0
    cover_percentage = 100
    detection_threshold = 10


func restart_level():
    %GameUI.get_node("%DefeatLayer").hide()
    reset_level_stats()
    %GameUI.update_people_to_judge_label(nb_persons_judged, total_nb_persons_to_judge)
    %GameUI.enter_new_character()
    
func update_level_characteristics(level: int):
    match str(level):
        "1":
            max_positive_actions_per_character = 2
            max_negative_actions_per_character = 2
            max_wrongly_positioned_actions_per_character = 0
            max_nb_deadly_actions = 0
            nb_persons_to_hell_to_complete_level = 6
            total_nb_persons_to_judge = 10
            cover_loss_multiplier = 0.7
            maximum_cover_loss = 80
        "2":
            max_positive_actions_per_character = 3
            max_negative_actions_per_character = 3
            max_wrongly_positioned_actions_per_character = 0
            max_nb_deadly_actions = 1
            nb_persons_to_hell_to_complete_level = 8
            total_nb_persons_to_judge = 15
            cover_loss_multiplier = 0.7
            maximum_cover_loss = 90
        "3":
            max_positive_actions_per_character = 3
            max_negative_actions_per_character = 3
            max_nb_deadly_actions = 1
            max_wrongly_positioned_actions_per_character = 1
            nb_persons_to_hell_to_complete_level = 8
            total_nb_persons_to_judge = 15
            cover_loss_multiplier = 0.8
            maximum_cover_loss = 100
        "4":
            max_positive_actions_per_character = 3
            max_negative_actions_per_character = 3
            max_nb_deadly_actions = 1
            max_wrongly_positioned_actions_per_character = 1
            nb_persons_to_hell_to_complete_level = 11
            total_nb_persons_to_judge = 20
            cover_loss_multiplier = 0.9
            maximum_cover_loss = 100
        "5":
            max_positive_actions_per_character = 3
            max_negative_actions_per_character = 3
            max_nb_deadly_actions = 1
            max_wrongly_positioned_actions_per_character = 1
            nb_persons_to_hell_to_complete_level = 14
            total_nb_persons_to_judge = 25
            cover_loss_multiplier = 1.0
            maximum_cover_loss = 100

func endgame():
    %GameUI.get_node("%EndGameLayer").show()
