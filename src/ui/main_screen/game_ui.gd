extends Control

var character: Character:
    set(value):
        character = value
        %CharacterUI.character = value

func _ready() -> void:
    %NextCharacterButton.disabled = true
    %RulesLayer.show()

func update_progress_bar(name_progress_bar: String, value: float):
    var progress_bar: ProgressBar
    match name_progress_bar:
        "hell":
            progress_bar = %HellBar
        "cover":
            progress_bar = %CoverBar
    await progress_bar.set_and_animate(value)

func hell_animation() -> void:
    await %CharacterUI.hell_animation()

func heaven_animation() -> void:
    await %CharacterUI.heaven_animation()

func victory():
    #%VictoryLayer.show()
    %NextLevelLayer.show()

func defeat():
    %DefeatLayer.show()

func disable_buttons() -> void:
    %HeavenButtonContainer.disable_button()
    %HellButtonContainer.disable_button()

func enable_next_character_call() -> void:
    if not %VictoryLayer.visible: #Hack
        %NextCharacterButton.disabled = false
    %CharacterUI.clear_action_containers()

func _on_next_character_button_pressed() -> void:
    Signals.emit_signal("next_character")
    %NextCharacterButton.disabled = true
    %HeavenButtonContainer.enable_button()
    %HellButtonContainer.enable_button()

func update_people_to_judge_label(nb_persons_judged: int, total_nb_persons_to_judge: int):
    var nb_people_to_judge_label = %GameUI.get_node("%NbPeopleToJudgeLabel")
    var base_string = "Number people to judge:\n%s /%s"
    nb_people_to_judge_label.text = base_string % [str(total_nb_persons_to_judge - nb_persons_judged), str(total_nb_persons_to_judge)]
