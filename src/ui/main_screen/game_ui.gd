extends Control

var character: Character:
    set(value):
        character = value
        %CharacterUI.character = value

func _ready() -> void:
    %HeavenButton.pressed.connect(func(): Signals.emit_signal("send_to_heaven"))
    %HellButton.pressed.connect(func(): Signals.emit_signal("send_to_hell"))
    %NextCharacterButton.disabled = true

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
    %VictoryLayer.show()

func defeat():
    %DefeatLayer.show()

func disable_buttons() -> void:
    %HeavenButton.disabled = true
    %HellButton.disabled = true

func enable_next_character_call() -> void:
    if not %VictoryLayer.visible: #Hack
        %NextCharacterButton.disabled = false
    %CharacterUI.clear_action_containers()

func _on_next_character_button_pressed() -> void:
    Signals.emit_signal("next_character")
    %NextCharacterButton.disabled = true
    %HeavenButton.disabled = false
    %HellButton.disabled = false
