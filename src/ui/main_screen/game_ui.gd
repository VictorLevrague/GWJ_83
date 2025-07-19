extends Control

var character: Character:
    set(value):
        character = value
        %CharacterUI.character = value

var new_rules: Array[String]

func _ready() -> void:
    %NextCharacterButton.disabled = true
    #%RulesLayer.show()

func update_progress_bar(name_progress_bar: String, value: float):
    var progress_bar: ProgressBar
    match name_progress_bar:
        "hell":
            progress_bar = %HellBar
            if value == 0:
                progress_bar.value = value
                return
        "cover":
            progress_bar = %CoverBar
            if value == 100:
                progress_bar.value = value
                return
    await progress_bar.set_and_animate(value)

func hell_animation() -> void:
    await %CharacterUI.hell_animation()

func heaven_animation() -> void:
    await %CharacterUI.heaven_animation()

func victory():
    %NextLevelLayer.show()

func defeat():
    %DefeatLayer.show()
    %NextCharacterButton.disabled = true

func disable_buttons() -> void:
    %HeavenButtonContainer.disable_button()
    %HellButtonContainer.disable_button()

func enable_buttons() -> void:
    %HeavenButtonContainer.enable_button()
    %HellButtonContainer.enable_button()

func enable_next_character_call() -> void:
    if not %NextLevelLayer.visible: #Hack
        %NextCharacterButton.disabled = false
    %CharacterUI.clear_action_containers()

func _on_next_character_button_pressed() -> void:
    enter_new_character()

func enter_new_character():
    Signals.emit_signal("next_character")
    AudioManager.get_node("%Bell").play()
    %NextCharacterButton.disabled = true
    enable_buttons()

func update_people_to_judge_label(nb_persons_judged: int, total_nb_persons_to_judge: int):
    var nb_people_to_judge_label = %GameUI.get_node("%NbPeopleToJudgeLabel")
    var base_string = "Number people to judge:\n%s /%s"
    nb_people_to_judge_label.text = base_string % [str(total_nb_persons_to_judge - nb_persons_judged), str(total_nb_persons_to_judge)]

func next_level(level: int):
    update_rules(level)
    %NextLevelLayer.hide()
    if level != 1:
        %RulesLayer.show()
    

func update_rules(level: int):
    var rules: String = "[center][color=red]Rules of the purgatory (Day %s):[/color][/center]\n" % [level]
    match str(level):
        "1":
            new_rules.append("\n∘ Judge people fairly based on the weight of their actions")
        "2":
            new_rules.append("\n∘ Tremendously positive and negative actions must lead to Heaven or Hell, respectively.")
        "3":
            new_rules.append("\n∘ Positive and negative action lists may have been mixed.")
    for new_rule in new_rules:
        rules = rules + new_rule
    %RulesLabel.text = rules
