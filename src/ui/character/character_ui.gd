extends Control

var character: Character:
    set(value):
        character = value
        if character:
            %Texture.texture = character.illustration
            %Texture.material = ShaderMaterial.new()
            fill_actions_container(%PositiveActionsContainer, character.positive_actions, Color(0.498039, 1, 0, 1))
            fill_actions_container(%NegativeActionsContainer, character.negative_actions, Color(1, 0, 0, 1))
        else:
            push_error("Missing full character")

func fill_actions_container(container: Container, actions: Array[Action], color: Color):
    clear(container)
    for action in actions:
        var label = load("res://src/ui/character/action_label.tscn").instantiate()
        var value_label = " (" + str(action.value) + ")"
        label.text = action.text + value_label if action.is_value_visible else action.text
        label.modulate = color
        container.add_child(label)

func hell_animation() -> void:
    #%Texture.material = ShaderMaterial.new()
    %Texture.material.set("shader", load("res://src/shaders/burn.gdshader"))
    %Texture.material.set("shader_parameter/noise", load("res://src/shaders/centered_noise.tres"))
    %Texture.material.set("shader_parameter/dissolve_threshold", 1.)
    var dissolve_tween = dissolve_tween()
    await dissolve_tween.finished
    

func dissolve_tween() -> Tween:
    var tween = get_tree().create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(%Texture.material, "shader_parameter/dissolve_threshold", 0, 1.5)
    return tween

func clear(container: Container):
    for child in container.get_children():
        child.queue_free()
