extends Control

var character: Character:
    set(value):
        character = value
        %CharacterUI.character = value

func _ready() -> void:
    %HeavenButton.pressed.connect(func(): Signals.emit_signal("send_to_heaven"))
    %HellButton.pressed.connect(func(): Signals.emit_signal("send_to_hell"))

func update_progress_bar(name_progress_bar: String, value: float):
    var progress_bar: ProgressBar
    match name_progress_bar:
        "hell":
            progress_bar = %HellBar
        "cover":
            progress_bar = %CoverBar
    progress_bar.set_and_animate(value)

func hell_animation() -> void:
    await %CharacterUI.hell_animation()

func heaven_animation() -> void:
    pass

func victory():
    %VictoryLayer.show()

func defeat():
    %DefeatLayer.show()
