extends CanvasLayer

func _on_hide_defeat_button_pressed() -> void:
    %DefeatPanel.visible = not %DefeatPanel.visible
    %DevilAngry.visible = not %DevilAngry.visible

func update_text(type: String):
    match type:
        "No_people_left_to_judge":
            %DefeatLabel.text = "THAT IS NOT ENOUGH SOULS !!!\n\nGO BACK TO HELL"
            %DevilAngry.show()
        "Cover_loss":
            %DefeatLabel.text = "WAIT A MINUTE !!! You're not the purgatory judge, you filthy demon.\n\nGET OUT"
            %DevilAngry.hide()
